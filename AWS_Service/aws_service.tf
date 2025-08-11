data "aws_ecs_cluster" "qa_cluster" {
  cluster_name = var.qa_cluster
}

data "aws_security_group" "qa_app_sg" {
  filter {
    name   = "group-name"
    values = [var.qa_security_group]
  }
  filter {
      name   = "vpc"
      values = [var.vpc]
    }
}

data "aws_subnet" "private1" {
  id = var.subnet_name[0]
}

data "aws_subnet" "private2" {
  id = var.subnet_name[1]
}

data "aws_lb" "qa_application_lb" {
  name = var.qa_application_lb
}

# Get the existing HTTPS listener
data "aws_lb_listener" "existing_listener" {
  load_balancer_arn = data.aws_lb.qa_application_lb.arn
  port              = 443
}

# Create target group
resource "aws_lb_target_group" "qa_target_groups" {
  name        = var.target_group
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = data.aws_subnet.private1.vpc_id
  target_type = "ip"

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = var.target_group
  }
}

# Create listener rule for specific host
resource "aws_lb_listener_rule" "qa_host_rule" {
  listener_arn = data.aws_lb_listener.existing_listener.arn
  priority = var.listener_rule_priority  # Let AWS automatically assign the next available priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.qa_target_groups.arn
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }

  tags = {
    Name = var.rule_name
    Environment = "qa"
    Service = var.ECS_service_name
  }
}

resource "aws_ecs_service" "qa_service" {
  name            = var.ECS_service_name
  cluster         = data.aws_ecs_cluster.qa_cluster.cluster_name
  task_definition = aws_ecs_task_definition.ECS_task_1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [data.aws_subnet.private1.id, data.aws_subnet.private2.id] // Replace with your private subnet IDs
    security_groups = [data.aws_security_group.qa_app_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.qa_target_groups.arn
    container_name   = var.container_name // Replace with your container name in the task definition
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_lb_listener_rule.qa_host_rule]
}

output "qa_security_group_id" {
  value = data.aws_security_group.qa_app_sg.id
}

output "qa_application_lb_dns" {
  value = data.aws_lb.qa_application_lb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.qa_target_groups.arn
}

output "listener_arn" {
  value = data.aws_lb_listener.existing_listener.arn
}

output "domain_endpoint" {
  value = "https://${var.domain_name}"
  description = "The endpoint URL for your service"
}

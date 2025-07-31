module "aws_task_defination" {
  source = "/" # Current directory
}
data "aws_ecs_cluster" "qa_cluster" {
  cluster_name = var.qa_cluster# Name of your existing ECS cluster
}

data "aws_security_group" "qa_app_sg" {
  filter {
    name   = "group-name"
    values = [var.qa_security_group]
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

data "aws_lb_target_group" "qa_target_groups" {
  name = var.target_group
}

data "aws_lb_listener" "qa_lb_listener" {
  load_balancer_arn = data.aws_lb.qa_application_lb.arn
  port = 443
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
    target_group_arn = data.aws_lb_target_group.qa_target_groups.arn
    container_name   = var.container_name // Replace with your container name in the task definition
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }
}

output "qa_security_group_id" {
  value = data.aws_security_group.qa_app_sg.id
}

output "qa_application_lb_dns" {
  value = data.aws_lb.qa_application_lb.dns_name
}

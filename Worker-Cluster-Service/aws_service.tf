data "aws_ecs_cluster" "qa_cluster" {
  cluster_name = var.qa_cluster
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

resource "aws_ecs_service" "qa_service" {
  name            = var.ECS_service_name
  cluster         = data.aws_ecs_cluster.qa_cluster.cluster_name
  task_definition = aws_ecs_task_definition.ECS_task_1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [data.aws_subnet.private1.id, data.aws_subnet.private2.id]
    security_groups = [data.aws_security_group.qa_app_sg.id]
    assign_public_ip = false
  }

  deployment_controller {
    type = "ECS"
  }
}

output "qa_security_group_id" {
  value = data.aws_security_group.qa_app_sg.id
}

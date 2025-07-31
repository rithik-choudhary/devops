data "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_task_definition" "ECS_task_1" {
  family                   = var.ECS_task_defiantion_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution.arn
  task_role_arn            = data.aws_iam_role.ecs_task_execution.arn
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = "${aws_ecr_repository.ECR_Repo.repository_url}:latest"

      essential = true
        portMappings = [
          {
            containerPort = var.container_port
            hostPort      = var.container_port
          }
        ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          # "awslogs-group"         = "/ecs/${local.task_family}"
          "awslogs-group" = "/ecs/${var.ECS_task_defiantion_name}"
          "awslogs-region"        = "eu-north-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.ECS_task_defiantion_name}"
  retention_in_days = 1
}

output "ecs_task_definition_arn" {
  value       = aws_ecs_task_definition.ECS_task_1.arn
  description = "The ARN of the ECS task definition"
}
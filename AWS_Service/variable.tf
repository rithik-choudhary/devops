variable "ECR_repository_name" {
  type = string
}
variable "ECS_task_defiantion_name" {
  type = string
}
# locals {
#   # task_family = "devops-td"
#   task_family = "${aws_ecr_repository.ECR_Repo.name}-td"

#   log_group   = "/ecs/${local.task_family}"
# }

variable "qa_cluster" {
    type = string
}
variable "region" {
    type = string
}
variable "qa_security_group" {
  type = string
}
variable "subnet_name" {
    type = list(string)
}
variable "qa_application_lb" {
  type = string
}
variable "ECS_service_name" {
  type = string
}
variable "container_name" {
    type = string
}
variable "container_port" {
    type = number
}
variable "target_group" {
    type = string  
}
variable "domain_name" {
  type = string
  description = "Domain name for the service (e.g., api.example.com)"
}
variable "rule_name" {
  type = string
  description = "Name for the listener rule (e.g., new-api-rule)"
}
variable "listener_rule_priority" {
  type        = number
  description = "Priority for the listener rule (1-50000)"
}


variable "ECR_repository_name" {
  type = string
}

variable "ECS_task_defiantion_name" {
  type = string
}

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

variable "ECS_service_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = number
}

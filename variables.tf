variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "eu-central-1"
}

variable "docker_nginx_image" {
  description = "Identification of docker image in ECR"
  type        = string
  default     = "nginx:latest"
}

variable "project_name" {
  default = "ecs-nginx-demo"
}

variable "env" {
  description = "Environment for resource naming"
  type        = string
  default     = "dev"   # Environment for resource naming. Can be dev, test, or prod
}

variable "app_name" {
  description = "Name of the web application"
  type        = string
  default     = "webapp"
}

variable "profile" {
  description = "Name of the AWS profile"
  type = string
  default = "private"   # AWS profile for credentials
}

variable "region" {
  description = "Name of the AWS region"
  type = string
  default = "us-west-2"
}

variable "cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the ECS task"
  type        = number
  default     = 512
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type = string

}

# VPC module outputs you’ll wire in:
variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

# App / ECS
variable "app_port" {
  type    = number
  default = 8000
} # Flask listens on 8000

variable "desired_count" {
  type    = number
  default = 2
}

# DB
variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "polls"
}

variable "db_username" {
  type    = string
  default = "admin"
}

variable "db_password" {
  type      = string
  sensitive = true
}

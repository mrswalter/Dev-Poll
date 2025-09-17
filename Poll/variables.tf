variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "devops_poll"
}

# VPC module outputs you’ll wire in:
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to deploy resources into"
}


variable "vpc_cidr" {
  description = "CIDR for VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones for subnets."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
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
  default = "mysql_poll"
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
  default = "azwe"
}

variable "db_password" {
  type      = string
  sensitive = true
}

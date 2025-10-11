# 🔹 Global
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "devops-poll"
}

# 🔹 VPC
variable "vpc_cidr" {
  description = "CIDR for VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones for subnets."
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# variable "private_subnets" {
#   type        = list(string)
#   description = "List of private subnet IDs"
# }

# variable "public_subnets" {
#   type        = list(string)
#   description = "List of public subnet IDs"
# }

# variable "vpc_id" {
#   type        = string
#   description = "The ID of the VPC to deploy resources into"
# }

# 🔹 ECS App
variable "app_port" {
  type    = number
  default = 8000
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "app_image" {
  description = "Docker image for ECS service."
  default     = "514670561567.dkr.ecr.us-east-1.amazonaws.com/poll-app:latest"
}

variable "ecs_cluster_id" {
  description = "ECS Cluster ID"
  type        = string
}

# variable "ecs_sg_id" {
#   description = "Security Group ID for ECS tasks"
#   type        = string
# }

# 🔹 RDS
variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  default     = "15.8"
  description = "Postgres engine version."
}

variable "db_instance_class" {
  default     = "db.t3.micro"
  description = "RDS instance size."
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "devopspolldb"
}

variable "db_username" {
  default     = "azwe"
  description = "Master username for PostgreSQL."
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password for PostgreSQL."
}

# 🔹 IAM
variable "execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role"
}

# variable "task_role_arn" {
#   type        = string
#   description = "ARN of the ECS task role"
# }

# 🔹 Grafana
variable "grafana_image" {
  default = "grafana/grafana:latest"
}

variable "grafana_admin_password" {
  default   = ""
  sensitive = true
}

# variable "grafana_sg_id" {
#   description = "Security Group ID for Grafana ECS service"
#   type        = string
# }

# 🔹 Prometheus
# variable "prometheus_sg_id" {
#   description = "Security Group ID for Prometheus ECS service"
#   type        = string
# }

# # 🔹 EFS
# variable "efs_sg_id" {
#   description = "Security Group ID for EFS mount targets"
#   type        = string
# }

# # 🔹 ALB
# variable "listener_arn" {
#   description = "ALB listener ARN for Grafana"
#   type        = string
# }

# variable "target_group_arn" {
#   description = "ALB target group ARN for poll-app"
#   type        = string
# }


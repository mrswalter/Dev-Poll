variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "devops-poll"
}

# VPC module outputs you’ll wire in:
# variable "vpc_id" {
#   type        = string
#   description = "The ID of the VPC to deploy resources into"
# }

variable "vpc_cidr" {
  description = "CIDR for VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability Zones for subnets."
  default     = ["us-east-1a", "us-east-1b"]
}

# variable "public_subnet_ids" {
#   type = list(string)
# }

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# variable "private_subnet_ids" {
#   type = list(string)
# }

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



# -----------------------------
# Database (RDS Postgres)
# -----------------------------

variable "db_engine" {
  type    = string
  default = "Postgres" # 🔹 Use "postgres" for PostgreSQL
}

variable "db_engine_version" {
  description = "Postgres engine version."
  default     = "15.2" # 🔹 Lock version for stability
}


variable "db_instance_class" {
  description = "RDS instance size."
  default     = "db.t3.micro" # 🔹 Smallest cheap option, upgrade if prod
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type    = string
  default = "devops-poll-db"
}

variable "db_username" {
  description = "Master username for PostgreSQL."
  default     = "azwe"
}

variable "db_password" {
  description = "Master password for PostgreSQL (sensitive)."
  sensitive   = true
  type        = string
}

variable "app_image" {
  description = "Docker image for ECS service."
  default     = "514670561567.dkr.ecr.us-east-1.amazonaws.com/poll-app:latest"
  # 🔹 Replace with your actual ECR repo + tag

}

# variable "alb_sg_id" {
#   type        = string
#   description = "Security Group ID for the ALB"
#   default     = "sg-0bd9a60ee693bd2df"
# }

# variable "rds_sg_id" {
#   type        = string
#   description = "Security Group ID for the RDS instance"
# }

# variable "ecs_sg_id" {
#   type        = string
#   description = "Security Group ID for the ECS tasks"
# }

# variable "public_subnets" {
#   type        = list(string)
#   description = "List of public subnet IDs"
# }

# variable "private_subnets" {
#   type        = list(string)
#   description = "List of private subnet IDs"
# }

variable "execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the ECS task role"
}

# variable "ecs_cluster_id" {
#   type        = string
#   description = "ID of the ECS cluster"
# }

# variable "listener_arn" {
#   type        = string
#   description = "ARN of the ALB listener"
# }

# variable "target_group_arn" {
#   type        = string
#   description = "ARN of the ALB target group"
# }

# variable "db_host" {
#   type        = string
#   description = "Hostname of the RDS instance"
#   #default     = "aws_db_instance.poll_db.address"
# }

# variable "db_user" {
#   type        = string
#   description = "Username for the RDS database"
#   default     = "azwe"
# }

# variable "db_port" {
#   type        = number
#   description = "Port for the RDS database"
#   default     = 5432
# }

# # variable "container_port" {
# #   type        = number
# #   description = "Port the container listens on"
# #   default     = 8000
# # }


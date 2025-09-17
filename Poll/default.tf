# -----------------------------
# Project Settings
# -----------------------------
variable "project_name" {
  description = "A name prefix for resources (helps keep names unique)."
  default     = "devops-poll" # 🔹 Change if you want a different project name
}

variable "region" {
  description = "AWS region to deploy into."
  default     = "us-east-1" # 🔹 Change if you use a different region
}

# -----------------------------
# Application / ECS
# -----------------------------
variable "app_image" {
  description = "Docker image for ECS service."
  default     = "514670561567.dkr.ecr.us-east-1.amazonaws.com/poll-app:latest"
  # 🔹 Replace with your actual ECR repo + tag
}

variable "container_port" {
  description = "Port your app listens on."
  default     = 80 # 🔹 Update if your app runs on another port
}

# -----------------------------
# Database (RDS Postgres)
# -----------------------------
variable "db_name" {
  description = "Name of the PostgreSQL database."
  default     = "polldb" # 🔹 You can rename if needed
}

variable "db_username" {
  description = "Master username for PostgreSQL."
  default     = "polluser" # 🔹 Change if you want a different DB user
}

variable "db_password" {
  description = "Master password for PostgreSQL (sensitive)."
  default     = "Admin123" # 🔹 MUST change to a secure password
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance size."
  default     = "db.t3.micro" # 🔹 Smallest cheap option, upgrade if prod
}

variable "db_allocated_storage" {
  description = "RDS storage (in GB)."
  default     = 20 # 🔹 Increase if your poll data grows
}

variable "db_engine_version" {
  description = "Postgres engine version."
  default     = "15.4" # 🔹 Lock version for stability
}

# -----------------------------
# Networking
# -----------------------------
variable "vpc_cidr" {
  description = "CIDR for VPC."
  default     = "10.0.0.0/16" # 🔹 Change if conflicts with your local network
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  # 🔹 Two AZs minimum for HA load balancer
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnets."
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
  # 🔹 Where ECS tasks and DB live
}

variable "azs" {
  description = "Availability Zones for subnets."
  default     = ["us-east-1a", "us-east-1b"]
  # 🔹 Pick at least 2 AZs in your region
}

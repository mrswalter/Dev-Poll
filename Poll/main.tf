# -----------------------------
# VPC
# -----------------------------
module "vpc" {
  source               = "./poll/modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

# -----------------------------
# Load Balancer (ALB)
# -----------------------------
module "load_balancer" {
  source         = "./poll/modules/load_balancer"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

# -----------------------------
# ECS Cluster
# -----------------------------
module "ecs_cluster" {
  source       = "./poll/modules/ecs_cluster"
  project_name = var.project_name
}

# -----------------------------
# RDS (Postgres)
# -----------------------------
module "rds" {
  source            = "./poll/modules/rds"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  allocated_storage = 20
  engine_version    = "15.4"
  instance_class    = "db.t3.micro"
}

# -----------------------------
# ECS Service (App + Poll Backend)
# -----------------------------
module "ecs_service" {
  source           = "./poll/modules/ecs_service"
  project_name     = var.project_name
  cluster_id       = module.ecs_cluster.cluster_id
  target_group_arn = module.load_balancer.target_group_arn
  private_subnets  = module.vpc.private_subnets
  app_image        = var.app_image
  container_port   = 80
  db_host          = module.rds.db_endpoint
  db_name          = var.db_name
  db_username      = var.db_username
  db_password      = var.db_password
}

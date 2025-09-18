# -----------------------------
# VPC
# -----------------------------
module "vpc" {
  source               = "./../modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

# -----------------------------
# Load Balancer (ALB)
# -----------------------------
module "load_balancer" {
  source         = "./../modules/load_balancer"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
}

# -----------------------------
# ECS Cluster
# -----------------------------
module "ecs_cluster" {
  source       = "./../modules/ecs_cluster"
  project_name = var.project_name
}

# -----------------------------
# RDS (Postgres)
# -----------------------------
module "rds" {
  source            = "./../modules/rds"
  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  allocated_storage = 20
  engine_version    = "15.4"
  db_instance_class = var.db_instance_class
}

# -----------------------------
# ECS Service (App + Poll Backend)
# -----------------------------
module "ecs_service" {
  source           = "./../modules/ecs_service"
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

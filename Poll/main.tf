# -----------------------------
# VPC
# -----------------------------
module "vpc" {
  source               = "./modules/vpc"
  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
  public_subnet_ids    = var.public_subnet_ids
  private_subnet_ids   = var.private_subnet_ids
}

# -----------------------------
# Load Balancer (ALB)
# -----------------------------
module "alb" {
  source         = "./modules/alb"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security_groups.alb_sg_id
}

# -----------------------------
# ECS Cluster
# -----------------------------
module "ecs_cluster" {
  source             = "./modules/ecs_cluster"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets_ids
  private_subnet_ids = module.vpc.private_subnets_ids
}

# -----------------------------
# RDS (Postgres)
# -----------------------------
module "rds" {
  source               = "./modules/rds"
  project_name         = var.project_name
  db_name              = var.db_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_instance_class    = var.db_instance_class
  depends_on           = [module.vpc]
  db_engine_version    = var.db_engine_version
  rds_sg_id            = module.vpc.rds_sg_id
  db_allocated_storage = var.db_allocated_storage
  db_engine            = var.db_engine
  private_subnet_ids   = var.private_subnet_ids
}

# -----------------------------
# ECS Service (App + Poll Backend)
# -----------------------------
module "ecs_service" {
  source             = "./modules/ecs_service"
  project_name       = var.project_name
  target_group_arn   = module.load_balancer.target_group_arn
  private_subnets    = module.vpc.private_subnets
  app_image          = var.app_image
  db_host            = module.rds.db_endpoint
  db_name            = var.db_name
  db_password        = var.db_password
  ecs_sg_id          = module.vpc.ecs_sg_id
  ecs_cluster_id     = module.ecs_cluster.cluster_id
  db_user            = var.db_username
  listener_arn       = module.load_balancer.listener_arn
  execution_role_arn = module.ecs_cluster.execution_role_arn
  task_role_arn      = module.ecs_cluster.task_role_arn
  db_port            = module.rds.db_port
}
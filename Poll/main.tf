# -----------------------------
# VPC
# -----------------------------
module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  #vpc_id             = module.vpc.vpc_id
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_ids    = module.vpc.public_subnets
  private_subnet_ids   = module.vpc.private_subnets
  azs                  = var.azs
}

# -----------------------------
# Security Groups
# -----------------------------
module "security_group" {
  source       = "./modules/security_group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  app_port     = var.app_port
  #db_port      = var.db_port
  private_subnet_cidrs = var.private_subnet_cidrs
}

# -----------------------------
# Load Balancer (ALB)
# -----------------------------
module "alb" {
  source       = "./modules/alb"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.public_subnets
  alb_sg_id    = module.security_group.alb_sg_id
  app_port     = var.app_port
  alb_arn      = module.alb.alb_arn
}

# -----------------------------
# ECS Cluster
# -----------------------------
module "ecs_cluster" {
  source             = "./modules/ecs_cluster"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnets
  private_subnet_ids = module.vpc.private_subnets
  depends_on         = [module.vpc]
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
  db_engine_version    = var.db_engine_version
  db_engine            = var.db_engine
  db_allocated_storage = var.db_allocated_storage
  rds_sg_id            = module.security_group.rds_sg_id
  private_subnet_ids   = module.vpc.private_subnets
  depends_on           = [module.vpc]
}

# -----------------------------
# ECS Service (App + Poll Backend)
# -----------------------------
module "ecs_service" {
  source           = "./modules/ecs_service"
  project_name     = var.project_name
  target_group_arn = module.alb.alb_target_group_arn
  listener_arn     = module.alb.listener_arn
  private_subnets  = module.vpc.private_subnets
  app_image        = var.app_image
  db_host          = module.rds.db_host
  db_name          = var.db_name
  db_user          = var.db_username
  db_password      = var.db_password
  #db_port          = module.rds.db_port
  ecs_sg_id      = module.security_group.ecs_sg_id
  ecs_cluster_id = module.ecs_cluster.ecs_cluster_id
  #db_host = module.rds.db_host
  #task_role_arn = var.task_role_arn
  execution_role_arn                = module.iam.execution_role_arn
  task_role_arn                     = module.iam.task_role_arn
  prometheus_efs_id                 = module.efs.prometheus_efs_id
  prometheus_image                  = var.prometheus_image
  prometheus_config_access_point_id = module.efs.prometheus_config_access_point_id
  depends_on                        = [module.rds, module.alb, module.ecs_cluster, module.iam, module.efs]
}


module "iam" {
  source                             = "./modules/iam"
  project_name                       = var.project_name
  prometheus_config_access_point_arn = module.efs.prometheus_config_access_point_arn
  depends_on                         = [module.efs]
}

resource "aws_cloudwatch_log_group" "poll_app_v3" {
  name              = "/ecs/poll-app_v3"
  retention_in_days = 7
}

# data "aws_cloudwatch_log_group" "poll_app_v2" {
#   name = "/ecs/poll-app_v2"
# }

module "efs" {
  source              = "./modules/efs"
  private_subnets_map = module.vpc.private_subnets_map
  efs_sg_id           = module.security_group.efs_sg_id
}


module "prometheus" {
  source                            = "./modules/monitoring/prometheus"
  ecs_cluster_id                    = module.ecs_cluster.ecs_cluster_id
  private_subnets                   = module.vpc.private_subnets
  prometheus_efs_id                 = module.efs.prometheus_efs_id
  prometheus_sg_id                  = module.security_group.prometheus_sg_id
  execution_role_arn                = module.iam.execution_role_arn
  task_role_arn                     = module.iam.task_role_arn
  prometheus_config_access_point_id = module.efs.prometheus_config_access_point_id

  depends_on = [module.efs, module.ecs_cluster, module.iam]
}

module "grafana" {
  source             = "./modules/monitoring/grafana"
  ecs_cluster_id     = module.ecs_cluster.ecs_cluster_id
  private_subnets    = module.vpc.private_subnets
  grafana_sg_id      = module.security_group.grafana_sg_id
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  grafana_image      = "grafana/grafana:latest"
  #grafana_admin_password = "admin"
  #aws_lb_listener        = module.alb.listener_arn
  target_group_arn = module.alb.grafana_tg_arn
}




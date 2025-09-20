module "ecs_service" {
  source    = "./modules/ecs_service"
  app_image = var.app_image
  #container_port     = var.container_port
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn
  # cluster_id         = module.ecs_cluster.cluster_id
  # subnet_ids         = module.vpc.private_subnets
  # service_sg_id      = module.security_group.ecs_sg_id
  target_group_arn = module.alb.target_group_arn
  #alb_listener_arn   = module.alb.listener_arn
  db_host         = module.rds.db_endpoint
  db_name         = var.db_name
  db_user         = var.db_username
  listener_arn    = var.listener_arn
  db_password     = var.db_password
  db_port         = module.rds.db_port
  project_name    = var.project_name
  ecs_sg_id       = (module.security_group.ecs_sg_id)
  ecs_cluster_id  = module.ecs_cluster.cluster_id
  private_subnets = module.vpc.private_subnets
  # target_group_arn = module.alb.target_group_arn
  depends_on = [module.alb, module.rds, module.ecs_cluster]
}


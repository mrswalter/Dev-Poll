output "alb_dns" {
  description = "Public URL of the app"
  value       = module.alb.alb_dns
}

output "alb_dns_name" {
  description = "URL of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_sg_id" {
  description = "Security Group ID for the ALB"
  value       = module.security_group.alb_sg_id
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_host
}

output "rds_port" {
  description = "RDS Port"
  value       = module.rds.db_port
}

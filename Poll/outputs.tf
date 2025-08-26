output "alb_dns" {
  description = "Public URL of the app"
  value       = module.load_balancer.alb_dns
}
output "db_endpoint" {
  value = module.rds.endpoint
}
output "alb_dns_name" {
  description = "URL of the load balancer"
  value       = module.load_balancer.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS Endpoint"
  value       = module.rds.db_endpoint
}
output "rds_port" {
  description = "RDS Port"
  value       = module.rds.port
}
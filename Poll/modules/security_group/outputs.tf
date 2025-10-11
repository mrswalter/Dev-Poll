output "alb_sg_id" { value = aws_security_group.alb_sg.id }
output "ecs_sg_id" { value = aws_security_group.ecs_sg.id }
output "rds_sg_id" { value = aws_security_group.rds_sg.id }
#output "alb_sg_id" { value = aws_security_group.alb.id }
#output "ecs_sg_id" { value = aws_security_group.ecs_sg.id }
# output "db_host" {
#   description = "RDS instance endpoint"
#   value       = aws_db_instance.poll_db.address
# }
# output "db_port" {
#   description = "RDS instance port"
#   value       = aws_db_instance.poll_db.port
# }

# output "alb_sg_id" {
#   description = "Security group ID for the ALB"
#   value       = aws_security_group.alb_sg.id
# }

output "efs_sg_id" {
  value = aws_security_group.efs.id
}

output "prometheus_sg_id" {
  value = aws_security_group.prometheus.id
}

output "grafana_sg_id" {
  value = aws_security_group.grafana.id
}
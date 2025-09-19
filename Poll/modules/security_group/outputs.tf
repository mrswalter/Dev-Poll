output "alb_sg_id" { value = aws_security_group.alb_sg.id }
output "ecs_sg_id" { value = aws_security_group.ecs_sg.id }
output "rds_sg_id" { value = aws_security_group.rds_sg.id }
#output "alb_sg_id" { value = aws_security_group.alb.id }
output "ecs_sg_id" { value = aws_security_group.ecs_sg.id }
output "db_host" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.poll_db.address
}
output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.poll_db.port
}
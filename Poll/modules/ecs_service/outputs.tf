output "ecs_task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "ecs_task_definition_family" {
  description = "Family name of the ECS task definition"
  value       = aws_ecs_task_definition.this.family
}

output "poll_app_container_name" {
  description = "Name of the poll-app container"
  value       = "poll-app"
}

output "prometheus_container_name" {
  description = "Name of the Prometheus container"
  value       = "prometheus"
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "ecs_service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.this.id
}
output "grafana_task_def_arn" {
  value = aws_ecs_task_definition.grafana.arn
}

output "grafana_service_id" {
  value = aws_ecs_service.grafana.id
}
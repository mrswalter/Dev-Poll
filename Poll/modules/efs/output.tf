output "prometheus_id" {
  value = aws_efs_file_system.prometheus.id
}

output "prometheus_efs_id" {
  value = aws_efs_file_system.prometheus.id
}

output "prometheus_config_access_point_id" {
  value = aws_efs_access_point.prometheus_config.id
}

output "prometheus_config_access_point_arn" {
  value = aws_efs_access_point.prometheus_config.arn
}
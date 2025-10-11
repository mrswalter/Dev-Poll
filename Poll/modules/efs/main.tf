resource "aws_efs_file_system" "prometheus" {
  creation_token = "prometheus-config"
  lifecycle_policy {
    transition_to_ia = "AFTER_7_DAYS"
  }
}

# resource "aws_efs_mount_target" "prometheus" {
#   for_each = toset(var.private_subnets)

#   file_system_id  = aws_efs_file_system.prometheus.id
#   subnet_id       = each.value
#   security_groups = [var.efs_sg_id]
# }

resource "aws_efs_mount_target" "prometheus" {
  for_each = var.private_subnets_map

  file_system_id  = aws_efs_file_system.prometheus.id
  subnet_id       = each.value
  security_groups = [var.efs_sg_id]
}


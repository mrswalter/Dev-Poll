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

resource "aws_efs_access_point" "prometheus_config" {
  file_system_id = aws_efs_file_system.prometheus.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/config"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "755"
    }
  }

  tags = {
    Name = "prometheus-config-access-point"
  }
}
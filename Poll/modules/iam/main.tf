resource "aws_iam_role" "execution" {
  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-ecs-execution-role"
  }
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-ecs-task-role"
  }
}

resource "aws_iam_role_policy" "task_policy" {
  name = "${var.project_name}-ecs-task-policy"
  role = aws_iam_role.task.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "rds:DescribeDBInstances",
          "ssm:GetParameters",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetDashboard"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "efs_access" {
  name = "AllowEFSAccess"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
          "elasticfilesystem:ClientRootAccess"
        ]
        Resource = var.prometheus_config_access_point_arn
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "efs_access_attachment" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.efs_access.arn
}

resource "aws_iam_role_policy" "execution_secrets" {
  name = "${var.project_name}-ecs-execution-secrets"
  role = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "arn:aws:secretsmanager:us-east-1:514670561567:secret:devops-poll-db-password-oF5ha0"
      }
    ]
  })
}


# resource "aws_ecs_task_definition" "this" {
#   family                   = "${var.project_name}-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = var.ecs_task_cpu
#   memory                   = var.ecs_task_memory
#   execution_role_arn       = aws_iam_role.execution.arn
#   task_role_arn            = aws_iam_role.task.arn

#   container_definitions = jsonencode([
#     {
#       name      = "poll-app"
#       image     = var.poll_app_image
#       essential = true
#       portMappings = [{
#         containerPort = 8080
#         hostPort      = 8080
#       }]
#       environment = [
#         {
#           name  = "DB_HOST"
#           value = var.db_host
#         },
#         {
#           name  = "DB_PORT"
#           value = var.db_port
#         },
#         {
#           name  = "DB_NAME"
#           value = var.db_name
#         },
#         {
#           name  = "DB_USER"
#           value = var.db_user
#         }
#       ]
#       secrets = [
#         {
#           name      = "DB_PASSWORD"
#           valueFrom = var.db_password_secret_arn
#         }
#       ]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = var.poll_app_log_group_name
#           awslogs-region        = var.aws_region
#           awslogs-stream-prefix = "ecs_poll_app"
#         }
#       }
#     },
#     {
#       name      = "prometheus"
#       image     = var.prometheus_image
#       essential = false
#       portMappings = [{
#         containerPort = 9090
#         hostPort      = 9090
#       }]
#       mountPoints = [{
#         containerPath = "/prometheus-config"
#         sourceVolume  = "prometheus-config"
#         readOnly      = false
#       }]
#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           awslogs-group         = var.prometheus_log_group_name
#           awslogs-region        = var.aws_region
#           awslogs-stream-prefix = "ecs_prometheus"
#         }
#       }
#     }
#   ])
#   volume {
#     name = "prometheus-config"
#     efs_volume_configuration {
#       file_system_id = var.prometheus_config_file_system_id
#       authorization_config {
#         access_point_id = var.prometheus_config_access_point_id
#         iam             = "ENABLED"
#       }
#       root_directory     = "/"
#       transit_encryption = "ENABLED"
#     }
#   }
#   depends_on = [
#     aws_cloudwatch_log_group.poll_app_log_group,
#     aws_cloudwatch_log_group.prometheus_log_group
#   ]
# }
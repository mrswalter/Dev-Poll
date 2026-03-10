resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "poll-app"
      image     = var.app_image
      essential = true
      portMappings = [{
        containerPort = 8000
        hostPort      = 8000
        protocol      = "tcp"
      }]
      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_NAME", value = var.db_name },
        { name = "DB_USER", value = var.db_user },
        { name = "FORCE_REVISION", value = "2" }
      ]

      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = data.aws_secretsmanager_secret_version.devops_poll_db_password.arn
          #aws_secretsmanager_secret.devops_poll_db_password.arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/poll-app_v4" #data.aws_cloudwatch_log_group.poll_app_v2.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs_app"
        }
      }
    },
    {
      name      = "prometheus"
      image     = var.prometheus_image
      essential = false
      portMappings = [{
        containerPort = 9090
        hostPort      = 9090
      }]
      mountPoints = [{
        containerPath = "/prometheus-config"
        sourceVolume  = "prometheus-config"
        readOnly      = false
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/prometheus"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  volume {
    name = "prometheus-config"

    efs_volume_configuration {
      file_system_id     = var.prometheus_efs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.prometheus_config_access_point_id
        iam             = "ENABLED"
      }
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.poll_app_v4, #data.aws_cloudwatch_log_group.poll_app_v2,
    aws_cloudwatch_log_group.prometheus
  ]
}

resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "poll-app"
    container_port   = 8000
  }

  depends_on = [var.listener_arn]
}

resource "aws_cloudwatch_log_group" "prometheus" {
  name              = "/ecs/prometheus"
  retention_in_days = 7

  tags = {
    Name = "prometheus-log-group"
  }
}

resource "aws_cloudwatch_log_group" "poll_app_v4" {
  name              = "/ecs/poll-app_v4"
  retention_in_days = 7

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "poll-app_v4-log-group"
  }
}
# data "aws_cloudwatch_log_group" "poll_app_v2" {
#   name = "/ecs/poll-app_v2"
# }
data "aws_secretsmanager_secret" "devops_poll_db_password" {
  name = "devops-poll-db-password"
}
data "aws_secretsmanager_secret_version" "devops_poll_db_password" {
  secret_id = data.aws_secretsmanager_secret.devops_poll_db_password.id
}




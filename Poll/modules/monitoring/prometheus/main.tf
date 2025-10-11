resource "aws_ecs_task_definition" "prometheus" {
  family                   = "prometheus"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "prometheus",
      image     = "prom/prometheus:latest",
      essential = true,
      portMappings = [{
        containerPort = 9090,
        protocol      = "tcp"
      }],
      mountPoints = [{
        sourceVolume  = "prometheus-config",
        containerPath = "/etc/prometheus"
      }]
    }
  ])

  volume {
    name = "prometheus-config"
    efs_volume_configuration {
      file_system_id = var.prometheus_efs_id
      root_directory = "/config"
    }
  }
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.prometheus.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.prometheus_sg_id]
    assign_public_ip = false
  }
}


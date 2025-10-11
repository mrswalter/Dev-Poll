resource "aws_ecs_task_definition" "grafana" {
  family                   = "grafana"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "grafana",
      image     = "grafana/grafana:latest",
      essential = true,
      portMappings = [{
        containerPort = 3000,
        protocol      = "tcp"
      }],
      environment = [
        { name = "GF_SECURITY_ADMIN_PASSWORD", value = "admin" }
      ]
    }
  ])
}

resource "aws_ecs_service" "grafana" {
  name            = "grafana"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.grafana.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.grafana_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "grafana"
    container_port   = 3000
  }

  #depends_on = [var.listener_arn]
}



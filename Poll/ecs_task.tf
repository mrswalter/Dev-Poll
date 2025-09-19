# variable "app_image" {
#   description = "Container image for the poll app"
#   type        = string
#   default     = "514670561567.dkr.ecr.us-east-1.amazonaws.com/poll-app:latest" # you can override in tfvars
# }

resource "aws_ecs_task_definition" "poll_app" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name         = "poll-app"
      image        = var.app_image
      essential    = true
      portMappings = [{ containerPort = var.app_port, hostPort = var.app_port }]
      environment = [
        { name = "DB_HOST", value = module.rds.endpoint },
        { name = "DB_USER", value = var.db_username },
        { name = "DB_PASS", value = var.db_password },
        { name = "DB_NAME", value = var.db_name }
      ]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.app_port}/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 20
      }
    }
  ])
}


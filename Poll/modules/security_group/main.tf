############################################
# ALB Security Group
############################################
resource "aws_security_group" "alb_sg" {
  name_prefix = "dplbsg"
  description = "Allow HTTP/HTTPS inbound to ALB"
  vpc_id      = var.vpc_id

  # ALB listens on 80 (and optionally 443)
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.lb_ingress_cidrs
  }

  # Optional HTTPS support
  # ingress {
  #   description = "Allow HTTPS from anywhere"
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = var.lb_ingress_cidrs
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

############################################
# ECS Security Group
############################################
resource "aws_security_group" "ecs_sg" {
  name_prefix = "ecssg" #name        = "${var.project_name}-ecs-sg"
  description = "Allow traffic from ALB to ECS tasks"
  vpc_id      = var.vpc_id

  # ECS tasks listen on var.app_port (8000)
  ingress {
    description     = "Allow ALB to reach ECS tasks"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ecs-sg"
  }
}

############################################
# RDS Security Group
############################################
resource "aws_security_group" "rds_sg" {
  name_prefix = "rdssg" #name        = "${var.project_name}-rds-sg"
  description = "Allow DB access from ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow DB access from ECS"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

############################################
# Prometheus SG
############################################
resource "aws_security_group" "prometheus" {
  name   = "prometheus_sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# Grafana SG
############################################
resource "aws_security_group" "grafana" {
  name   = "grafana-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# EFS SG
############################################
resource "aws_security_group" "efs" {
  name_prefix = "efs-sg" #name        = "${var.project_name}-efs-sg"
  description = "Security group for EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-efs-sg"
  }
}
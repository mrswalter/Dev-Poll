variable "project_name" {
  description = "A name prefix for resources (helps keep names unique)."
  default     = "devops-poll" # 🔹 Change if you want a different project prefix
}

variable "vpc_id" {

}
variable "subnet_ids" {
  type = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB."
  type        = string
}

variable "app_port" {
  description = "Port for the application (ECS tasks)."

}
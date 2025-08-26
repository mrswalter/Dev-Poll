variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "app_port" { type = number }
variable "db_port" {
  type    = number
  default = 3306
}
variable "lb_ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

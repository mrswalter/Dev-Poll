variable "project_name" {
  description = "A name prefix for resources (helps keep names unique)."
  default     = "devops-poll" # 🔹 Change if you want a different project prefix
}

variable "vpc_id" {

}
variable "public_subnets" {
  type = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for the ALB."
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "514670561567" #"999568710647"
}

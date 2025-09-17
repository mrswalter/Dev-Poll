variable "project_name" {
  description = "A name prefix for resources (helps keep names unique)."
  default     = "devops-poll" # 🔹 Change if you want a different project prefix
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy resources into"
  type        = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}
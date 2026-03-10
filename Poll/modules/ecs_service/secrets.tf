# resource "aws_secretsmanager_secret" "devops_poll_db_password" {
#   name = "devops-poll-db-password"
# }

# resource "aws_secretsmanager_secret_version" "devops_poll_db_password" {
#   secret_id     = aws_secretsmanager_secret.devops_poll_db_password.id
#   secret_string = var.db_password
# }

# # resource "aws_secretsmanager_secret" "devops_poll_db_username" {
# #   name = "devops-poll-db-username"
# # }
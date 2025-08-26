terraform {
  backend "s3" {
    bucket         = "your-tfstate-bucket" # 🔹 Replace with your S3 bucket name
    key            = "devops-poll/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-tf-locks" # 🔹 Replace with your DynamoDB table name
    encrypt        = true
  }
}
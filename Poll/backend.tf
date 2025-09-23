terraform {
  backend "s3" {
    bucket         = "state-storage-36" # 🔹 Replace with your S3 bucket name
    key            = "dev-poll/terraform.tfstate"
    region         = "us-east-1"
    use_lock_table = true # ✅ new parameter
    #
  }
}
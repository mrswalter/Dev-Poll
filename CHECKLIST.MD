**Setup Checklist for Poll App (Terraform + ECS + GitHub Actions)**

Before deploying, update the following values:

🔹 Terraform Variables (variables.tf)

- aws_region → e.g., us-east-1
- project_name → e.g., poll-app
- vpc_cidr → default is 10.0.0.0/16
- public_subnet_cidrs → e.g., 10.0.1.0/24, 10.0.2.0/24
- instance_type → e.g., t3.micro
- key_name → your EC2 key pair (if SSH needed)

🔹 ECS Task Definition (ecs_task.tf)
- image → Replace with your AWS Account ID + region + ECR repo name
Example:123456789012.dkr.ecr.us-east-1.amazonaws.com/poll-app:latest
- containerPort / hostPort → 80 (change if app runs on another port)

🔹 Terraform Backend (backend.tf)

- bucket → Your S3 bucket for storing Terraform state
- key → Path for the .tfstate file
-region → Same as aws_region
- dynamodb_table → DynamoDB table for state locking

🔹 GitHub Actions Workflow (.github/workflows/ci-cd.yml)

 -AWS_REGION → e.g., us-east-1-
 ECR_REPOSITORY → e.g., poll-app-
 AWS_ACCOUNT_ID → Your AWS account ID

🔹 Dockerfile

 Ensure your frontend files match names used:
-index.html
-style.css
-script.js
- Update EXPOSE 80 if app runs on a different port

🔹 GitHub Secrets

Add the following in repo → Settings → Secrets and variables → Actions:
- AWS_ACCESS_KEY_ID-
- AWS_SECRET_ACCESS_KEY
-AWS_REGION

🔹 README.md
- Replace placeholders in setup steps with your actual values.


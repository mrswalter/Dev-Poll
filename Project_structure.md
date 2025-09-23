

**Project Structure:**

poll-fullstack/
├── .github/workflows/ci-cd.yml
├── app/
│   ├── poll.py
│   ├── requirements.txt
│   ├── index.html
│   ├── style.css
│   └── script.js
├── terraform/
│   ├── backend.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── ecs_task.tf
│   └── modules/
│       ├── vpc/
│       ├── rds/
│       ├── ecs_cluster/
│       ├── ecs_service/
│       ├── load_balancer/
│       └── security_groups/
├── Dockerfile
├── .gitignore
└── CHECKLIST.md





**Areas of CUSTOMIZATION:**

🔑 Areas Requiring Input / Customization
1. Terraform Variables (variables.tf or .tfvars)

You’ll need to provide values for these:

-AWS region → aws_region
-VPC & Subnet CIDRs → vpc_cidr, public_subnet_cidrs
-Project name / resource prefix → project_name
-Instance type (for ECS EC2 launch type) → instance_type
-Key pair (for SSH access if required) → key_name
-Desired capacity (ECS ASG size) → desired_capacity
-ECR repo name (if you want a custom one) → ecr_repo_name
-Frontend/backend port numbers → frontend_port, backend_port

2. ECS Task Definition (ecs_task.tf)
If hardcoding the image:

image = "123456789012.dkr.ecr.us-east-1.amazonaws.com/poll-app:latest"
You must replace:
AWS account ID
Region
Repository name

3. Backend Configuration (backend.tf)
bucket         = "my-terraform-backend-bucket"
dynamodb_table = "my-terraform-locks"
region         = "us-east-1"

Replace with your:
S3 bucket name (must exist)
DynamoDB table name (must exist)
Region

4. GitHub Actions Workflow (.github/workflows/ci-cd.yml)

Modify:
AWS_REGION → your region
ECR_REPOSITORY → must match repo in AWS ECR
AWS_ACCOUNT_ID → your account ID
Optionally adjust terraform plan & terraform apply conditions


5. Dockerfile

If your poll app changes:
Replace index.html, style.css, script.js with your actual app files.
Modify EXPOSE if your app runs on a different port.

6. .gitignore

Usually nothing to edit unless you have extra files. Defaults cover:
.terraform/
terraform.tfstate*
*.tfplan
.DS_Store
node_modules/ (if frontend uses npm)

7. README.md

You’ll customize:
Project name & description
How to deploy (region, AWS account setup, GitHub secrets)
Architecture diagram (optional, recommended)

8. Secrets in GitHub

Must set:
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
(Optional) TF_VAR_key_name if SSH is required


🔍 Summary of Input Points

Terraform variables → Infra customization
ECS task definition → Docker image details
Backend config → S3 & DynamoDB for state
Workflow YAML → ECR repo, AWS account/region
Dockerfile → App files and port
README.md → Documentation
GitHub Secrets → Credentials



The real structure of this Project

output "endpoint" { value = aws_db_instance.this.address }
output "db_port" { value = aws_db_instance.this.port }
output "db_host" { value = aws_db_instance.this.address }
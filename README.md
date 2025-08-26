# DevOps Poll App 🚀

This is a simple **polling application** deployed on AWS using **Terraform + ECS + RDS + ALB**.

## Features
- Flask app with MySQL backend
- Containerized with Docker
- Terraform modules for VPC, ECS, RDS, and ALB
- CI/CD pipeline using GitHub Actions
- Stores Terraform state in S3 with DynamoDB lock

## Deployment

### 1. Prerequisites
- AWS account
- Terraform >= 1.5
- Docker installed
- GitHub repo with secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

### 2. Clone Repo
```sh
git clone https://github.com/youruser/devops-poll.git
cd devops-poll


*** Security intergrated ***

🔒 Security in this Project
1. AWS Security Groups

RDS security group:

Allows inbound traffic only from the ECS task security group (not open to the public).

Ensures database is not exposed to the internet.

ECS/EC2 security group:

Allows inbound HTTP/HTTPS from the load balancer only.

Outbound traffic is restricted to required services (RDS, ECR, updates).

2. Database Credentials & Secrets

Credentials for RDS (username, password, DB name) are not hardcoded.

Instead:

Stored in Terraform variables, ideally injected via GitHub Actions secrets.

ECS Task Definition passes them as environment variables.

✅ This way, poll.py connects to the DB securely with no credentials inside the repo.

3. ECS Task Role & Execution Role (IAM)

ECS Task Execution Role:

Only allows pulling images from ECR + pushing logs to CloudWatch.

ECS Task Role:

Grants only the permissions needed (e.g., talk to RDS if IAM auth used in future).

Principle of Least Privilege is applied.

4. Networking

VPC with private + public subnets:

RDS is deployed in private subnets (no internet access).

ECS tasks run in private subnets with a NAT Gateway for updates.

Load balancer sits in public subnets, facing users.

5. Docker Image Security

The Dockerfile uses a lightweight base image (e.g., python:3.11-slim) to reduce attack surface.

Python dependencies pinned in requirements.txt to avoid unexpected updates.

Optional: Can integrate Trivy scan in GitHub Actions pipeline for vulnerabilities.

6. GitHub Actions Security

Terraform backend S3 + DynamoDB uses encryption.

AWS credentials stored as GitHub Encrypted Secrets.

Prevents accidental leakage of keys.

✅ So yes:

The poll.py backend + RDS are integrated with security best practices applied (private networking, secrets management, IAM least privilege, security groups, encrypted backend, and CI/CD secrets protection).
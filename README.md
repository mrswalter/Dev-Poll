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

#########################
#After build procedures#
#########################

Where to Look in AWS Console
🔹 Amazon ECS
Go to ECS > Clusters

Look for a cluster named something like devops-poll-cluster

Inside, check:

Services → your running service

Tasks → active containers

Task Definitions → verify your image and roles

🔹 Elastic Load Balancing (ALB)
Go to EC2 > Load Balancers

Look for an ALB named poll-alb or similar

Check:

DNS name (should match your alb_dns output)

Listeners and Target Groups → confirm routing to ECS

🔹 Amazon RDS
Go to RDS > Databases

Look for devops-poll-db

Check:

Endpoint (should match your db_host output)

Connectivity & security → subnet group, security group, etc.

🔹 IAM Roles
Go to IAM > Roles

Look for:

devops-poll-ecs-execution-role

devops-poll-ecs-task-role

Confirm attached policies like AmazonECSTaskExecutionRolePolicy

🔹 CloudWatch Logs
Go to CloudWatch > Logs > Log groups

Look for log groups tied to your ECS service or task definition

🛠️ Optional: Use Terraform Outputs
If you added outputs in your root outputs.tf, you can run:

bash
cd Poll
terraform output
This will show values like:

alb_dns

db_host

cluster_name

service_name

🧪 Want to Test It?
Try hitting your ALB DNS in the browser or with curl:

bash
curl http://<alb_dns>
If everything’s wired correctly, you should see your app respond!





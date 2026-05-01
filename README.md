# 🚀 Terraform AWS CI/CD Modular Infrastructure

A production-style Infrastructure as Code (IaC) project built using Terraform and AWS, featuring a modular architecture, remote backend state management, and automated CI/CD deployment using GitHub Actions.

## 📌 Project Overview

This project demonstrates how to design and deploy a scalable cloud infrastructure on AWS using Terraform. It follows real-world DevOps practices including modularization, state management, and CI/CD automation.

The infrastructure is fully automated — any push to the main branch triggers a GitHub Actions pipeline that provisions AWS resources.

## 🏗️ Architecture

![](<screenshots/Architecture Diagram terraform.png>)

#### The project deploys:

* VPC with public subnets
* Internet Gateway & Route Tables
* Security Groups
* EC2 instances (Auto Scaling enabled)
* Application Load Balancer (ALB)
* Target Groups
* Auto Scaling Group (ASG)
* S3 Remote Backend (State Storage)
* DynamoDB (State Locking)
* CI/CD Pipeline (GitHub Actions)


## ⚙️ Tech Stack

 * Terraform
 * Amazon Web Services (AWS)
        - EC2
        - VPC
        - ALB (Elastic Load Balancer)
        - Auto Scaling Group
        - S3
        - DynamoDB
 * GitHub Actions (CI/CD)
 * Linux (Amazon Linux 2)


## 📁 Project Structure
.
├── main.tf
├── provider.tf
├── backend.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── network/
│   ├── security/
│   ├── compute/
│   ├── alb/
│   └── asg/
└── .github/
    └── workflows/
        └── terraform.yml

## 🔄 CI/CD Pipeline

#### The GitHub Actions pipeline performs:

* Checkout repository
* Configure AWS credentials
* Initialize Terraform (terraform init)
* Validate configuration
* Plan infrastructure changes (terraform plan)
* Apply changes automatically (terraform apply)

## ☁️ Remote State Management

Terraform state is stored securely using:

    * S3 Bucket → Stores state file
    * DynamoDB Table → Handles state locking

This ensures safe collaboration and prevents concurrent modifications.


## 🚀 Deployment Workflow
Git Push → GitHub Actions → Terraform Init → Plan → Apply → AWS Infrastructure

## 🔐 Security

* IAM user with least-privilege access
* No hardcoded credentials
* GitHub Secrets used for AWS authentication
* State locking enabled via DynamoDB


## 📸 Screenshots

🔹 ALB Working in Browser

![](<screenshots/Browser output.png>)


🔹 GitHub Actions Pipeline

![](<screenshots/GitHub Action success.png>)


🔹 AWS EC2 Instances, ALB, ASG, Target Group, DynamoDb, S3 Bucket,VPC

![](<screenshots/EC2 instances.png>)

![](screenshots/ALB.png)

![](screenshots/ASG.png)

![](<screenshots/Target Group.png>)

![](<screenshots/dynamodb lock table.png>)

![](<screenshots/S3 bucket.png>)

![](<screenshots/VPC .png>)

🔹 Inline Policy created for GitHub actions

![](<screenshots/Inline policy for gitHub actions.png>)


🔹 Terraform Apply Output

![](<screenshots/Terminal output-Terraform apply.png>)



## 🧠 Key Learnings

* Modular Terraform architecture design
* Infrastructure as Code best practices
* AWS networking and compute services
* CI/CD automation using GitHub Actions
* Remote state management using S3 + DynamoDB
* Secure IAM-based authentication


## 🎯 Outcome

This project simulates a real-world production cloud environment, enabling:

    * Fully automated infrastructure deployment
    * Scalable and fault-tolerant architecture
    * Secure and version-controlled cloud setup

## 📌 How to Use

# Clone repository
git clone <repo-url>

# Initialize Terraform
terraform init

# Plan infrastructure
terraform plan

# Apply infrastructure
terraform apply


## 💡 Future Improvements

* HTTPS using Route53 + ACM
* Blue/Green deployment strategy
* CloudWatch monitoring & alerts
* Multi-environment setup (dev/staging/prod)
* Cost optimization strategies


## 👨‍💻 Author

### Fathima Yosra

AWS Cloud & Devops Engineer

Focused on AWS, Terraform, and CI/CD automation.

⭐ If you like this project

Give it a ⭐ on GitHub and follow for more DevOps projects.##
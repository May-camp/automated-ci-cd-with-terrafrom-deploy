Automated CI/CD Infrastructure Deployment with Terraform and LocalStack
This project demonstrates a fully automated DevOps CI/CD pipeline that utilizes GitLab CI/CD to validate, plan, and deploy AWS networking infrastructure into a local cloud environment using LocalStack and Terraform.

By using LocalStack, we mock real AWS services inside Docker containers, allowing for safe, cost-effective, and fast infrastructure testing without touching a live AWS production environment.

🚀 Features
Infrastructure as Code (IaC): Managed using Terraform v1.5.7.

Local Cloud Emulation: Simulated AWS environment running via LocalStack (latest).

Automated CI/CD Pipeline: Structured multi-stage pipeline (validate -> plan -> apply -> destroy) built completely on GitLab CI.

Container Networking: Configured isolated Docker-in-Docker bridge networking inside GitLab Runners to allow secure communication between Terraform and LocalStack.

🛠️ Architecture Overview
The pipeline executes inside GitLab Runner containers. When the pipeline triggers, itspins up a parallel LocalStack service container on a shared Docker network bridge using the GitLab FF_NETWORK_PER_BUILD feature flag.

[ GitLab Runner (Terraform Container) ]
               │
               ▼ (Performs Local DNS Lookup)
   http://localstack:4566
               │
               ▼
[ LocalStack Service Container (Mocking AWS EC2/VPC APIs) ]
📁 Repository Structure
Plaintext
├── .gitlab-ci.yml      # CI/CD Pipeline Configuration
├── provider.tf         # Terraform Provider configured for LocalStack endpoints
└── vpc/
    └── main.tf         # AWS Network Resources (VPC, Subnets, Security Groups)

💻 Code Configuration
1. Terraform Provider (provider.tf)
The AWS provider is overridden to redirect all service endpoints to the running LocalStack container instead of the actual AWS public cloud endpoints.

2. Pipeline Configuration (.gitlab-ci.yml)
The pipeline runs through separate isolated jobs. It exposes the LocalStack service to every individual job container dynamically.

🚦 Pipeline Stages Explanations
Validate (terraform validate): Checks the code syntax and resource block formatting to ensure it complies with Terraform specifications.

Plan (terraform plan): Dry-runs the configuration and outputs the execution plan showing what resources will be created inside LocalStack.

Apply (terraform apply): Executes the resource configuration and provisions the VPC, Subnets, and Security Groups inside the LocalStack container.

Destroy (terraform destroy): Completely tears down and cleans up the mock resources to free runner memory resources.

<img width="1380" height="752" alt="ci cd diagram" src="https://github.com/user-attachments/assets/5ffe8f80-8070-4076-b51a-a3b56d370d00" />

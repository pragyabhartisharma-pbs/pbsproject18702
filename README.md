# Static Website Deployment with Terraform & GitHub Actions

This project deploys a static website to Azure Storage using Terraform and GitHub Actions.

🔗 **Live Website:** https://pbscapstoneweb.z29.web.core.windows.net/

## Project Structure
.github/workflows/
 └─ deploy.yml

app/
 └─ index.html

infra/
 ├─ main.tf
 ├─ variables.tf
 ├─ outputs.tf
 └─ terraform.tfvar

screenshots/
.gitignore

## How It Works
Terraform creates the Azure Storage resources, and GitHub Actions automatically deploys the static website on each push.

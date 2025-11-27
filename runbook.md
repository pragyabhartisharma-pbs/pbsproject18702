# RUNBOOK – Capstone Project 18702  
Static Website Deployment Using Terraform & GitHub Actions

This runbook describes how to deploy, rollback, monitor, and troubleshoot the static website hosted on Azure Storage using Terraform and GitHub Actions.

---

## 1. Overview
This project deploys a static website (`index.html`) to Azure Storage Static Website hosting.  
Infrastructure is managed with **Terraform**, and deployments run automatically through **GitHub Actions**.

Azure resources provisioned:
- Resource Group  
- Storage Account (Static Website)  
- `$web` container with `index.html`  
- Key Vault + secret  
- Log Analytics Workspace  
- Diagnostic Settings  
- Metric Alert (Availability < 99%)  
- Action Group (Email)

---

## 2. Deployment Procedure

### ✔ Automatic Deployment (via GitHub Actions)
1. Commit and push changes to the **main** branch.
2. GitHub Actions pipeline will automatically:
   - Log in to Azure  
   - Run Terraform Init  
   - Run Terraform Validate  
   - Run Terraform Plan  
   - Run Terraform Apply  
3. Once completed, all Azure resources are provisioned/updated.
4. Terraform uploads the **index.html** file to the `$web` container.

_No manual steps are required._

---

## 3. Manual Deployment (If Needed)

If GitHub Actions is not available:

```
cd infra
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply -auto-approve tfplan
```

This will recreate the infrastructure exactly as defined.

---

## 4. Rollback Procedure

### ✔ Rollback via Git
1. Identify the last stable commit.
2. Run:
   ```
   git revert <commit-id>
   ```
3. Push to `main`.
4. Pipeline will re-deploy previous stable state.

### ✔ Full Teardown (Only if required)
```
cd infra
terraform destroy -auto-approve
```

This removes all Azure resources.

---

## 5. Managing Key Vault & Secrets

### View a secret:
Azure Portal → Key Vault → Secrets → Select secret  
(This project has only a dummy secret.)


---

## 6. Monitoring & Alerts

### ✔ Metric Alert (Availability < 99%)
- Location: Azure Portal → Monitor → Alerts → Alert Rules  
- Alert name: **storage-availability-alert**
- Action Group: **capstone-action-group** (email)

### ✔ Diagnostic Settings
Check:
- Storage Account → Diagnostic settings → Log Analytics
- Key Vault → Diagnostic settings → Log Analytics

Logs are forwarded to the Log Analytics Workspace.

---

## 7. Cost Management

### ✔ Budget Alert
- Azure Portal → Cost Management → Budgets

  
---

## 8. Troubleshooting

### ❗ Terraform Errors
- Ensure Azure credentials in GitHub Secrets are correct  
- Run manually:
  ```
  terraform validate
  terraform plan
  ```

### ❗ Website not loading
- Go to Storage Account → Static Website  
- Ensure:
  - Static website is enabled  
  - `$web` container exists  
  - `index.html` exists  

### ❗ Alert not firing
- Ensure correct metric:
  - Metric: **Availability**
  - Condition: `< 99`
  - Scope: Storage Account  
- Make sure alert is **enabled**

### ❗ GitHub Actions pipeline fails
Check logs via:  
GitHub → Repository → Actions → Latest run → Failed step

Common issues:
- Wrong working directory  
- Terraform syntax error  
- Missing Azure login  

---

## 9. Recovery Steps
- Re-run pipeline manually using “Re-run all jobs”  
- Reapply Terraform using:
  ```
  terraform apply
  ```
- Upload index.html manually if needed:
  Azure Portal → Storage Account → Containers → `$web` → Upload

---

## 10. Contact
**Owner:** Pragya Bharti Sharma  
Email: Pragya.Sharma@rsystems.com

---


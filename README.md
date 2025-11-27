# Static Website Deployment with Terraform & GitHub Actions

This project deploys a static website on Azure Storage using Terraform for Infrastructure as Code (IaC) and GitHub Actions for CI/CD automation.

🔗 **Live Website:** https://pbscapstoneweb.z29.web.core.windows.net/

---

## 📁 Project Structure
```
.github/workflows/
 └─ deploy.yml            # CI/CD pipeline

app/
 └─ index.html            # Static website

infra/
 ├─ main.tf               # Core Terraform configuration
 ├─ variables.tf          # Input variables
 ├─ outputs.tf            # Outputs
 └─ terraform.tfvars      # Environment configuration

screenshots/              # All proof screenshots
RUNBOOK.md                # Deployment & troubleshooting guide
README.md                 # Project documentation
```

---

## 🏗️ Infrastructure (Terraform)

Terraform provisions the following Azure resources:

- **Resource Group**
- **Storage Account** (Static Website enabled)
- **$web container** + automatic upload of `index.html`
- **Azure Key Vault** + secret (dummy)
- **Log Analytics Workspace**
- **Diagnostic Settings**  
  - Storage → Log Analytics  
  - Key Vault → Log Analytics
- **Metric Alert** (Storage Availability < 99%)
- **Action Group** (email notifications)
- **Tags** for governance
- **Azure Budget** + cost alert

This infrastructure represents a minimal, production-style Azure deployment.

---

## 🔄 CI/CD Pipeline (GitHub Actions)

The GitHub Actions workflow (`deploy.yml`) runs on every push to `main`:

1. Checkout repository  
2. Azure login using Service Principal  
3. Terraform init → validate → plan → apply  
4. Upload static website files to the `$web` container  

This ensures automated, consistent deployments.

---

## 🔐 Security & Governance

- Secrets stored in **Azure Key Vault**
- No secrets or credentials in the repository
- SAS token (short expiry) used for Blob operations
- Resource tagging for cost tracking:
  - `owner`
  - `env`
  - `cost_center`
  - `app`
  - `data_classification`
- Azure Budget configured to monitor monthly spend

---

## 📊 Observability

- **Log Analytics Workspace** collects logs & metrics
- **Diagnostic settings** enabled for Storage and Key Vault
- **Metric alert** monitors Storage availability (< 99%)
- Alerts routed through **Action Group** to email

---

## 🧪 Screenshots (Proof)

All required screenshots are available in the `screenshots/` folder:

- Static website deployed  
- Blob operations  
- Key Vault secret  
- SAS token  
- Metric alert firing  
- Budget alert  
- GitHub Actions pipeline run  
- Resource overview  

These confirm successful deployment and meet evaluation requirements.

---

## 📘 Runbook & Lessons Learned

See **RUNBOOK.md** for:

- Deployment steps  
- Rollback procedure  
- Secrets handling  
- Monitoring & alert response  
- Basic troubleshooting

### Lessons Learned
- Terraform enables consistent, repeatable IaC deployments  
- Diagnostic settings help improve observability  
- CI/CD automation reduces manual deployment effort  
- Azure Storage is cost-efficient for static websites  
- Tagging is essential for governance and cost control  
- Monitoring + alerts ensure reliability and uptime  

---

## ✔ Submission Checklist (YC Requirements)

| Deliverable | Status |
|------------|--------|
| Repo (infra + app) | ✔ Completed |
| Live website | ✔ Available |
| Pipeline run screenshot | ✔ Included |
| Blob/KV/SAS proofs | ✔ Included |
| Alert screenshot | ✔ Included |
| Budget screenshot | ✔ Included |
| Architecture diagram | ✔ Included |
| Runbook | ✔ Completed |
| Lessons learned | ✔ Added |

---

## 🎯 Conclusion

This project fulfills the Capstone requirement of deploying a minimal production-style static website on Azure with complete IaC, CI/CD, security, observability, and cost governance.


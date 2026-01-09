# Docker App

A sample .NET Docker application with infrastructure as code (IaC) templates for Azure deployment.

## Infrastructure Deployment Options

This repository includes infrastructure templates in both **Bicep** and **Terraform** formats for deploying to Azure. Choose the tool that best fits your workflow:

### Bicep (Azure-native)
- Native Azure Resource Manager (ARM) template language
- Tight integration with Azure CLI
- See individual `*.bicep` files in the `azd/` directory

### Terraform (Multi-cloud)
- HashiCorp's infrastructure as code tool
- Works across multiple cloud providers
- See individual `*.tf` files in the `azd/` directory
- **[📖 Terraform Documentation](azd/TERRAFORM.md)**

## Deployment Targets

Both Bicep and Terraform support the following Azure deployment options:

| Option | Description | Bicep Files | Terraform Files |
|--------|-------------|-------------|-----------------|
| **ACA** | Azure Container Apps | `azd/aca/*.bicep` | `azd/aca/*.tf` |
| **ACI** | Azure Container Instance | `azd/aci/*.bicep` | `azd/aci/*.tf` |
| **AKS** | Azure Kubernetes Service | `azd/aks/*.bicep` | `azd/aks/*.tf` |
| **ACR** | Azure Container Registry (module) | `azd/acr/modules/*.bicep` | `azd/acr/modules/*.tf` |

## Quick Start

### Using Bicep
```bash
cd azd/aca
az deployment sub create \
  --location eastus \
  --template-file main.bicep \
  --parameters environmentName=myenv location=eastus
```

### Using Terraform
```bash
cd azd/aca
terraform init
terraform apply -var="environment_name=myenv" -var="location=eastus"
```

For detailed Terraform usage, see **[TERRAFORM.md](azd/TERRAFORM.md)**.

## Application

The application is a .NET Docker app located in the `src/` directory. Build it using:

```bash
docker build -t docker-app .
```

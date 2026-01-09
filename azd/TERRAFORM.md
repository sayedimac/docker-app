# Terraform Infrastructure

This directory contains Terraform configurations that are equivalent to the Bicep templates in this repository. You can choose to use either Bicep or Terraform for deploying the infrastructure.

## Structure

Each deployment option has its own directory with Terraform configurations:

- **aca/** - Azure Container Apps deployment
- **aci/** - Azure Container Instance deployment
- **aks/** - Azure Kubernetes Service deployment
- **acr/** - Standalone Azure Container Registry module

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads) >= 1.0
2. [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. An active Azure subscription

## Authentication

Before running Terraform, authenticate with Azure:

```bash
az login
```

## Usage

### Azure Container Apps (ACA)

```bash
cd azd/aca

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan -var="environment_name=myenv" -var="location=eastus"

# Apply the configuration
terraform apply -var="environment_name=myenv" -var="location=eastus"
```

### Azure Container Instance (ACI)

```bash
cd azd/aci

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan -var="environment_name=myenv" -var="location=eastus"

# Apply the configuration
terraform apply -var="environment_name=myenv" -var="location=eastus"
```

### Azure Kubernetes Service (AKS)

```bash
cd azd/aks

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan -var="environment_name=myenv" -var="location=eastus"

# Apply the configuration
terraform apply -var="environment_name=myenv" -var="location=eastus"
```

## Variables

Each deployment option has configurable variables. Here are the common ones:

### Required Variables

- `environment_name` - Name of the environment (1-64 characters)
- `location` - Azure region (e.g., "eastus", "westus2")

### Optional Variables (ACA)

- `container_image` - Container image to deploy (default: "docker-app")
- `container_port` - Port the container listens on (default: 80)
- `cpu_cores` - CPU cores allocated (default: "0.5")
- `memory_in_gb` - Memory allocated (default: "1Gi")

### Optional Variables (ACI)

- `container_image` - Container image to deploy (default: "mcr.microsoft.com/azuredocs/aci-helloworld")
- `container_port` - Port the container listens on (default: 80)
- `cpu_cores` - CPU cores allocated (default: "1.0")
- `memory_in_gb` - Memory in GB (default: "1.5")

### Optional Variables (AKS)

- `agent_count` - Number of agent nodes (default: 3, range: 1-100)
- `agent_vm_size` - VM size for nodes (default: "Standard_D2s_v3")
- `os_disk_size_gb` - OS disk size in GB (default: 0, range: 0-1023)
- `os_type` - Operating system type (default: "Linux", options: "Linux", "Windows")

## Using Variable Files

You can create a `terraform.tfvars` file to store your variables:

```hcl
environment_name = "myenv"
location         = "eastus"
container_image  = "myregistry.azurecr.io/myapp"
container_port   = 8080
```

Then run:

```bash
terraform apply
```

## Outputs

Each configuration provides outputs that can be used for further automation:

- `AZURE_LOCATION` - The Azure region where resources are deployed
- `AZURE_CONTAINER_REGISTRY_ENDPOINT` - Container registry login server
- `AZURE_CONTAINER_REGISTRY_NAME` - Container registry name
- Additional outputs specific to each deployment type

## Comparison with Bicep

| Feature | Bicep | Terraform |
|---------|-------|-----------|
| Language | ARM Template DSL | HCL (HashiCorp Configuration Language) |
| Provider | Azure-specific | Multi-cloud (Azure, AWS, GCP, etc.) |
| State Management | Server-side (Azure) | Client-side (local or remote backend) |
| Module System | Bicep modules | Terraform modules |
| Validation | `az bicep build` | `terraform validate` |
| Preview Changes | `az deployment what-if` | `terraform plan` |
| Apply Changes | `az deployment create` | `terraform apply` |

## Clean Up

To destroy all resources created by Terraform:

```bash
terraform destroy -var="environment_name=myenv" -var="location=eastus"
```

Or if using a tfvars file:

```bash
terraform destroy
```

## Notes

- The Terraform configurations are functionally equivalent to their Bicep counterparts
- Both Bicep and Terraform files are maintained in this repository for flexibility
- The `.terraform/` directory and state files are git-ignored for security
- Always review the `terraform plan` output before applying changes

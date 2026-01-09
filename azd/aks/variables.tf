variable "environment_name" {
  type        = string
  description = "Name of the environment which is used to generate a short unique hash used in all resources."

  validation {
    condition     = length(var.environment_name) >= 1 && length(var.environment_name) <= 64
    error_message = "Environment name must be between 1 and 64 characters."
  }
}

variable "location" {
  type        = string
  description = "Primary location for all resources"

  validation {
    condition     = length(var.location) >= 1
    error_message = "Location must be specified."
  }
}

variable "agent_count" {
  type        = number
  description = "The number of nodes for the cluster. 1 Node is enough for Dev/Test and minimum 3 nodes, is recommended for Production"
  default     = 3

  validation {
    condition     = var.agent_count >= 1 && var.agent_count <= 100
    error_message = "Agent count must be between 1 and 100."
  }
}

variable "agent_vm_size" {
  type        = string
  description = "The size of the Virtual Machine"
  default     = "Standard_D2s_v3"
}

variable "os_disk_size_gb" {
  type        = number
  description = "Disk size (in GiB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize."
  default     = 0

  validation {
    condition     = var.os_disk_size_gb >= 0 && var.os_disk_size_gb <= 1023
    error_message = "OS disk size must be between 0 and 1023."
  }
}

variable "os_type" {
  type        = string
  description = "The type of operating system"
  default     = "Linux"

  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be either Linux or Windows."
  }
}

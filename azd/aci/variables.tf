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

variable "container_image" {
  type        = string
  description = "The container image to deploy"
  default     = ""
}

variable "container_port" {
  type        = number
  description = "Port the container listens on"
  default     = 80
}

variable "cpu_cores" {
  type        = string
  description = "CPU cores allocated to the container instance"
  default     = "1.0"
}

variable "memory_in_gb" {
  type        = string
  description = "Memory allocated to the container instance in GB"
  default     = "1.5"
}

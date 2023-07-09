variable "tenant_id" {
  description = "Deployment Azure Tenant ID"
  type        = string
  sensitive   = true
}

variable "subscription_id" {
  description = "Deployment Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment Environment Name"
  type        = string
  default     = "prod"
}

variable "location" {
  description = "Deployment Environment Location"
  type        = string
  default     = "eastus"
}


locals {
  application                  = "snek_case"
  workspace_root               = "/workspaces/template-python"
  app_dockerfile_relative_path = "./snek_case/Dockerfile"
  app_checksum                 = sha1(join("", [for f in fileset(path.module, "../../snek_case/*") : filesha1(f)]))
  tags = {
    application = local.application
    environment = var.environment
  }
}

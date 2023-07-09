# backend config: https://developer.hashicorp.com/terraform/language/settings/backends/azurerm
terraform {
  backend "azurerm" {
    container_name = "terraform"
    key            = "/snek_case/dev.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.55.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

# Use mounted docker service in container from host machine
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

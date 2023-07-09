resource "azurerm_resource_group" "application" {
  name     = join("-", ["rg", local.application, var.environment])
  location = var.location
  tags     = local.tags
}

resource "azurerm_container_registry" "application" {
  name                = "acr${local.application}${var.environment}"
  depends_on          = [azurerm_resource_group.application]
  resource_group_name = azurerm_resource_group.application.name
  location            = azurerm_resource_group.application.location
  sku                 = "Basic"
  admin_enabled       = true
  tags                = local.tags
}

# Provide docker auth to push to ACR
provider "docker" {
  alias = "acr_authorized"
  registry_auth {
    address  = azurerm_container_registry.application.login_server
    username = azurerm_container_registry.application.admin_username
    password = azurerm_container_registry.application.admin_password
  }
}

# Build image if application changes
resource "docker_image" "application" {
  name         = "${azurerm_container_registry.application.login_server}/${local.application}:latest"
  depends_on   = [azurerm_container_registry.application]
  keep_locally = true
  build {
    context    = local.workspace_root
    dockerfile = local.app_dockerfile_relative_path
  }
  triggers = {
    application_checksum = local.app_checksum
  }
}

# Push image if application changes
resource "docker_registry_image" "application" {
  name       = docker_image.application.name
  depends_on = [docker_image.application]
  provider   = docker.acr_authorized
  triggers = {
    application_checksum = local.app_checksum
  }
}

resource "azurerm_log_analytics_workspace" "application" {
  name                = join("-", ["log", local.application, var.environment])
  depends_on          = [azurerm_resource_group.application]
  resource_group_name = azurerm_resource_group.application.name
  location            = azurerm_resource_group.application.location
  tags                = local.tags
}

resource "azurerm_container_app_environment" "application" {
  name                       = join("-", ["cae", local.application, var.environment])
  depends_on                 = [azurerm_resource_group.application, azurerm_log_analytics_workspace.application]
  resource_group_name        = azurerm_resource_group.application.name
  location                   = azurerm_resource_group.application.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.application.id
  tags                       = local.tags
}

resource "azurerm_container_app" "application" {
  name                         = join("-", ["ca", local.application, var.environment])
  depends_on                   = [azurerm_resource_group.application, azurerm_container_app_environment.application, docker_registry_image.application]
  resource_group_name          = azurerm_resource_group.application.name
  container_app_environment_id = azurerm_container_app_environment.application.id
  revision_mode                = "Single"
  tags                         = local.tags

  ingress {
    external_enabled = true
    target_port      = 8008
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  secret {
    name  = join("-", ["cas", azurerm_container_registry.application.name, "pw"])
    value = azurerm_container_registry.application.admin_password
  }

  registry {
    server               = azurerm_container_registry.application.login_server
    username             = azurerm_container_registry.application.admin_username
    password_secret_name = join("-", ["cas", azurerm_container_registry.application.name, "pw"])
  }

  template {
    container {
      name   = join("-", ["cntr", local.application, var.environment])
      image  = "${azurerm_container_registry.application.login_server}/${local.application}:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
    min_replicas = 0
    max_replicas = 10
  }
}

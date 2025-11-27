provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# -------------------------
# Resource Group
# -------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# -------------------------
# Storage Account for Static Website
# -------------------------
resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}


data "azurerm_storage_account" "storage_data" {
  name                = azurerm_storage_account.storage.name
  resource_group_name = azurerm_resource_group.rg.name
}



#Static Website
resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

# -------------------------
# Upload index.html to $web container
# -------------------------
resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "../app/index.html"
  content_type           = "text/html"
}

# -------------------------
# Key Vault
# -------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                     = var.keyvault_name
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  tenant_id                = data.azurerm_client_config.current.tenant_id
  sku_name                 = "standard"
  purge_protection_enabled = false
  tags                     = var.tags
}


# -------------------------
# Log Analytics Workspace
# -------------------------
resource "azurerm_log_analytics_workspace" "log" {
  name                = var.log_analytics_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# -------------------------
# Correct Diagnostics for Storage Account
# -------------------------
resource "azurerm_monitor_diagnostic_setting" "diag_storage" {
  name                       = "storage-diagnostics"
  target_resource_id         = azurerm_storage_account.storage.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# -------------------------
# Correct Diagnostics for Key Vault
# -------------------------
resource "azurerm_monitor_diagnostic_setting" "diag_kv" {
  name                       = "kv-diagnostics"
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

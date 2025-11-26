
provider "azurerm" {
  features {}  
  subscription_id = "ac6e8c49-833e-427d-bcc4-87042af5ddaf"
}

# -------------------------
# Resource Group
# -------------------------

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name  # Name comes from variables.tf
  location = var.location             # Location comes from variables.tf
  tags     = var.tags                 # Tags come from variables.tf
}

# -------------------------
# Storage Account for Static Website
# -------------------------

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"       # Standard tier storage
  account_replication_type = "LRS"            # Locally redundant storage
  tags                     = var.tags
}



resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.storage.id
  index_document     = "index.html"
  error_404_document = "index.html"
}



# -------------------------
# Upload index.html to static website
# -------------------------
resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"                           # File name in Azure
  storage_account_name   = azurerm_storage_account.storage.name   # Storage account created above
  storage_container_name = "$web"                                  # Must be $web for static website
  type                   = "Block"                                 # Block blob type
  source                 = "../app/index.html"                         # Path to your local index.html
  content_type           = "text/html" 
}


data "azurerm_storage_account" "storage_data" {
  name                = azurerm_storage_account.storage.name
  resource_group_name = azurerm_resource_group.rg.name
}



# -------------------------
# Key Vault
# --------------------------
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id  # Who owns the vault
  sku_name                    = "standard"
  purge_protection_enabled    = false
  tags                        = var.tags
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


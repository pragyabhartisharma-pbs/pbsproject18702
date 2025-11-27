output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}
output "static_website_url" {
  value = data.azurerm_storage_account.storage_data.primary_web_endpoint
}
output "keyvault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log.id
}



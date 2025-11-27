# Resource group name
variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "pbscapstonerg"
}

# Azure region
variable "location" {
  description = "Region where resources will be created"
  type        = string
  default     = "Central India"
}

# subscription id
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

# Storage account name 
variable "storage_account_name" {
  description = "Name of Azure Storage Account"
  type        = string
  default     = "pbscapstoneweb"
}

# Key Vault name
variable "keyvault_name" {
  description = "Name of Key Vault"
  type        = string
  default     = "pbscapstonekv"
}

# Log Analytics Workspace name
variable "log_analytics_name" {
  description = "Name of Log Analytics Workspace"
  type        = string
  default     = "pbscapstonelog"
}

# Tags for resources
variable "tags" {
  description = "Tags applied to all resources for organization"
  type        = map(string)
  default = {
    Owner       = "Pragya"
    Project     = "capstoneproject18702"
    Environment = "Dev"
  }
}


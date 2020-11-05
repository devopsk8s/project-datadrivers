//resource group
output "resource_group_name" {
  value = azurerm_resource_group.az_resource_group.name
}
output "resource_group_location" {
  value = azurerm_resource_group.az_resource_group.location
}
//storage account
output "storage_account_id" {
  value = azurerm_storage_account.az_storage_account.id
}
output "storage_account_name" {
  value = azurerm_storage_account.az_storage_account.name
}
output "storage_account_primary_connection_string" {
  value = azurerm_storage_account.az_storage_account.primary_connection_string
}
output "storage_account_primary_access_key" {
  value = azurerm_storage_account.az_storage_account.primary_access_key
}
output "storage_account_primary_dfs_endpoint" {
  value = azurerm_storage_account.az_storage_account.primary_dfs_endpoint
}
output "storage_account_identity" {
  value = azurerm_storage_account.az_storage_account.identity
}

//data factory
output "data_factory_id" {
  value = azurerm_data_factory.az_data_factory.id
}
output "data_factory_identity" {
  value = azurerm_data_factory.az_data_factory.identity
}
output "data_factory_identity_tenant_id" {
  value = azurerm_data_factory.az_data_factory.identity[0].tenant_id
}
output "data_factory_identity_principal_id" {
  value = azurerm_data_factory.az_data_factory.identity[0].principal_id
}
output "data_factory_name" {
  value = azurerm_data_factory.az_data_factory.name
}
// Storage Container
output "storage_account_storage_container_name" {
  value = azurerm_storage_container.az_storage_container.name
}
output "storage_account_storage_container_access_type" {
  value = azurerm_storage_container.az_storage_container.container_access_type
}
// Storage Blob
output "storage_account_storage_blob_input_id" {
  value = azurerm_storage_blob.az_storage_blob_input.id
}
output "storage_account_storage_blob_input_url" {
  value = azurerm_storage_blob.az_storage_blob_input.url
}
output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.az_storage_account.primary_blob_endpoint
}

//Key Vault
output "key_vault_name" {
  description = "Key Vault Name"
  value       = azurerm_key_vault.az_key_vault.name
}
output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.az_key_vault.id
}
output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.az_key_vault.vault_uri
}
# //Secrets
output "key_vault_storage_secrets" {
  value = azurerm_key_vault_secret.az_storage_key.value
}
output "key_vault_storage_secrets_name" {
  value = azurerm_key_vault_secret.az_storage_key.*.name
}
output "key_vault_storage_secrets_id" {
  value = azurerm_key_vault_secret.az_storage_key.id
}
output "key_vault_storage_secrets_version" {
  value = azurerm_key_vault_secret.az_storage_key.version
}

# output "pipeline_trigger_schedule_id" {
#   value = azurerm_data_factory_trigger_schedule.pipeline_trigger_schedule.id
# }

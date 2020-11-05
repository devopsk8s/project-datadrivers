data "azurerm_client_config" "current" {
}

// resource group 
resource "azurerm_resource_group" "az_resource_group" {
  name     = "${var.project}-${var.env}-${var.rg_suffix}"
  location = var.resource_group_location
}

//Data Factory
resource "azurerm_data_factory" "az_data_factory" {
  name                = "${var.project}-${var.env}-${var.df_suffix}"
  location            = azurerm_resource_group.az_resource_group.location
  resource_group_name = azurerm_resource_group.az_resource_group.name

  identity {
    type = var.identity_type
  }

  github_configuration {
    account_name    = var.account_name
    branch_name     = var.branch_name
    git_url         = var.git_url
    repository_name = var.repository_name
    root_folder     = "${var.project}-${var.env}-${var.df_suffix}"
  }

}

//Storage Account
resource "azurerm_storage_account" "az_storage_account" {
  name                = "${var.project}${var.env}${var.sa_suffix}"
  location            = azurerm_resource_group.az_resource_group.location
  resource_group_name = azurerm_resource_group.az_resource_group.name

  account_tier             = var.sa_account_tier
  access_tier              = var.sa_access_tier
  account_replication_type = var.sa_account_replication_type
  account_kind             = var.sa_account_kind
  is_hns_enabled           = var.sa_is_hns_enabled

  tags = {
    environment = var.environment
  }
}

//Role Assignment
# resource "azurerm_role_assignment" "az_role_assignment_current_user" {
#   depends_on           = [azurerm_storage_account.az_storage_account]
#   scope                = azurerm_storage_account.az_storage_account.id
#   role_definition_name = var.role_definition_owner
#   principal_id         = data.azurerm_client_config.current.object_id
# }

resource "azurerm_role_assignment" "az_role_assignment_service_principal" {
  depends_on           = [azurerm_storage_account.az_storage_account]
  scope                = azurerm_storage_account.az_storage_account.id
  role_definition_name = var.role_definition_owner
  principal_id         = var.service_principal_object_id
}

resource "azurerm_role_assignment" "az_role_assignment_data_factory" {
  depends_on           = [azurerm_data_factory.az_data_factory, azurerm_storage_account.az_storage_account]
  scope                = azurerm_storage_account.az_storage_account.id
  role_definition_name = var.role_definition_owner
  principal_id         = azurerm_data_factory.az_data_factory.identity[0].principal_id
}

//Storage container blob
resource "azurerm_storage_container" "az_storage_container" {
  depends_on            = [azurerm_storage_account.az_storage_account]
  name                  = "${var.project}-${var.sc_suffix}"
  storage_account_name  = azurerm_storage_account.az_storage_account.name
  container_access_type = var.container_access_type
}
resource "azurerm_storage_blob" "az_storage_blob_input" {
  depends_on             = [azurerm_storage_container.az_storage_container]
  name                   = "${var.input_folder}/${var.input_test_file}"
  storage_account_name   = azurerm_storage_account.az_storage_account.name
  storage_container_name = azurerm_storage_container.az_storage_container.name
  type                   = var.storage_blob_type
  source                 = "./files/${var.input_test_file}"
}

//ACL
resource "null_resource" "az_storage_account_set_acl" {
  depends_on = [azurerm_storage_blob.az_storage_blob_input]

  triggers = {
    "acl" = azurerm_storage_blob.az_storage_blob_input.name
  }

  provisioner "local-exec" {
    #working_dir = "./files"
    command     = "ls ./files && chmod 777 -R ./files && ./files/storage_account_acl.sh"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      "AZURE_STORAGE_KEY"       = azurerm_storage_account.az_storage_account.primary_access_key
      "AZURE_STORAGE_ACCOUNT"   = azurerm_storage_account.az_storage_account.name
      "AZURE_STORAGE_CONTAINER" = azurerm_storage_container.az_storage_container.name
      "AZURE_STORAGE_AUTH_MODE" = var.storage_auth_mode
      "ACL"                     = var.storage_acl
      "INPUTS_PATH"             = var.input_folder
      "OUTPUTS_PATH"            = var.output_folder
      "INPUT_FILE"              = var.input_test_file
    }
  }
}

//Key Vault
resource "azurerm_key_vault" "az_key_vault" {
  depends_on          = [azurerm_data_factory.az_data_factory]
  name                = "${var.project}-${var.env}-${var.kv_suffix}"
  location            = azurerm_resource_group.az_resource_group.location
  resource_group_name = azurerm_resource_group.az_resource_group.name

  enabled_for_deployment          = var.kv_vm_deployment
  enabled_for_disk_encryption     = var.kv_disk_encryption
  enabled_for_template_deployment = var.kv_template_deployment

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = var.sku_name
  tags = {
    environment = var.environment
  }
  network_acls {
    default_action = var.network_acls_default_action
    bypass         = var.network_acls_bypass
  }
}

//Key Vault policy
resource "azurerm_key_vault_access_policy" "key_vault_access_policy_data_factory" {
  key_vault_id            = azurerm_key_vault.az_key_vault.id
  tenant_id               = azurerm_data_factory.az_data_factory.identity[0].tenant_id
  object_id               = azurerm_data_factory.az_data_factory.identity[0].principal_id
  key_permissions         = var.kv_key_permissions_read
  secret_permissions      = var.kv_secret_permissions_read
  certificate_permissions = var.kv_certificate_permissions_read
  storage_permissions     = var.kv_storage_permissions_read
  depends_on              = [azurerm_key_vault.az_key_vault]
}

resource "azurerm_key_vault_access_policy" "default_policy" {
  key_vault_id = azurerm_key_vault.az_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  lifecycle {
    create_before_destroy = true
  }
  key_permissions         = var.kv_key_permissions_full
  secret_permissions      = var.kv_secret_permissions_full
  certificate_permissions = var.kv_certificate_permissions_full
  storage_permissions     = var.kv_storage_permissions_full
  depends_on              = [azurerm_key_vault.az_key_vault]
}

resource "azurerm_key_vault_access_policy" "service_principal_policy" {
  depends_on   = [azurerm_key_vault.az_key_vault]
  key_vault_id = azurerm_key_vault.az_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.service_principal_object_id
  lifecycle {
    create_before_destroy = true
  }
  key_permissions         = var.kv_key_permissions_read
  secret_permissions      = var.kv_secret_permissions_read
  certificate_permissions = var.kv_certificate_permissions_read
  storage_permissions     = var.kv_storage_permissions_read
}

resource "azurerm_key_vault_secret" "az_storage_key" {
  depends_on   = [azurerm_key_vault_access_policy.default_policy]
  name         = var.storage_key_name
  value        = azurerm_storage_account.az_storage_account.primary_access_key
  key_vault_id = azurerm_key_vault.az_key_vault.id
  tags         = {} 
  }

//Linked services
resource "azurerm_data_factory_linked_service_key_vault" "linked_service_data_factory_key_vault" {
  depends_on          = [azurerm_data_factory.az_data_factory, azurerm_key_vault.az_key_vault]
  name                = "${var.linked_service_df_kv_name}${upper(var.kv_suffix)}"
  resource_group_name = azurerm_resource_group.az_resource_group.name
  data_factory_name   = azurerm_data_factory.az_data_factory.name
  key_vault_id        = azurerm_key_vault.az_key_vault.id
}

resource "azurerm_template_deployment" "linked_service_dataset_datalakestore" {
  depends_on          = [azurerm_data_factory.az_data_factory, azurerm_data_factory_linked_service_key_vault.linked_service_data_factory_key_vault]
  name                = var.linked_service_ds_adls_name
  resource_group_name = azurerm_resource_group.az_resource_group.name

  template_body = file("./files/arm_templates/arm_linked_service_blobstorage.json")

  parameters = {
    "factoryName"                          = azurerm_data_factory.az_data_factory.name
    "keyVaultReferenceName"                = azurerm_data_factory_linked_service_key_vault.linked_service_data_factory_key_vault.name
    "secretName"                           = azurerm_key_vault_secret.az_storage_key.name
    "secretVersion"                        = azurerm_key_vault_secret.az_storage_key.version
    "AzureBlobStorageLinkedService"        = var.linked_service_df_bs_name
    "linked_properties_typeProperties_url" = azurerm_storage_account.az_storage_account.primary_dfs_endpoint
  }

  deployment_mode = "Incremental"
  provisioner "local-exec" {
    when        = destroy
    #working_dir = "./files"
    command     = "chmod 777 -R ./files && ./files/destroy_resource.sh"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      RESOURCE_ID = self.outputs.linkedServiceId
    }
  }
}

// Datasets
resource "azurerm_data_factory_dataset_delimited_text" "input_delimited_dataset" {
  depends_on          = [azurerm_data_factory.az_data_factory, azurerm_template_deployment.linked_service_dataset_datalakestore]
  name                = var.dataset_input_name
  resource_group_name = azurerm_resource_group.az_resource_group.name
  data_factory_name   = azurerm_data_factory.az_data_factory.name
  linked_service_name = var.linked_service_df_bs_name

  azure_blob_storage_location {
    container = azurerm_storage_container.az_storage_container.name
    path      = var.input_folder
    filename  = var.input_test_file
  }

  column_delimiter    = var.column_delimiter
  row_delimiter       = var.row_delimiter
  encoding            = var.encoding
  quote_character     = var.quote_character
  escape_character    = var.escape_character
  first_row_as_header = var.first_row_as_header
  null_value          = var.null_value
}

resource "azurerm_data_factory_dataset_delimited_text" "output_delimited_dataset" {
  depends_on          = [azurerm_data_factory.az_data_factory, azurerm_template_deployment.linked_service_dataset_datalakestore]
  name                = var.dataset_output_name
  resource_group_name = azurerm_resource_group.az_resource_group.name
  data_factory_name   = azurerm_data_factory.az_data_factory.name
  linked_service_name = var.linked_service_df_bs_name

  azure_blob_storage_location {
    container = azurerm_storage_container.az_storage_container.name
    path      = var.output_folder
    filename  = var.input_test_file
  }

  column_delimiter    = var.column_delimiter
  row_delimiter       = var.row_delimiter
  encoding            = var.encoding
  quote_character     = var.quote_character
  escape_character    = var.escape_character
  first_row_as_header = var.first_row_as_header
  null_value          = var.null_value
}

//Pipeline
resource "azurerm_data_factory_pipeline" "data_factory_pipeline_01" {
  depends_on          = [azurerm_data_factory.az_data_factory, azurerm_key_vault.az_key_vault]
  name                = var.pipeline_name
  resource_group_name = azurerm_data_factory.az_data_factory.resource_group_name
  data_factory_name   = azurerm_data_factory.az_data_factory.name
}

resource "azurerm_template_deployment" "pipeline_deployment" {
  depends_on          = [azurerm_data_factory.az_data_factory, azurerm_data_factory_pipeline.data_factory_pipeline_01]
  name                = "${var.pipeline_name}-deployment"
  resource_group_name = azurerm_resource_group.az_resource_group.name

  template_body = file("./files/arm_templates/arm_data_factory_pipeline.json")
  parameters = {
    "factoryName"   = azurerm_data_factory.az_data_factory.name
    "inputDataset"  = azurerm_data_factory_dataset_delimited_text.input_delimited_dataset.name
    "outputDataset" = azurerm_data_factory_dataset_delimited_text.output_delimited_dataset.name
    "pipelineName"  = azurerm_data_factory_pipeline.data_factory_pipeline_01.name
    "activityName"  = var.activity_name
  }

  deployment_mode = "Incremental"
  provisioner "local-exec" {
    when        = destroy
    #working_dir = "./files"
    command     = "chmod 777 -R ./files && ./files/destroy_resource.sh"
    interpreter = ["/bin/bash", "-c"]

    environment = {
      RESOURCE_ID = self.outputs.pipelineId
    }
  }
}

# resource "azurerm_data_factory_trigger_schedule" "pipeline_trigger_schedule" {
#   depends_on          = [azurerm_data_factory.az_data_factory, azurerm_template_deployment.pipeline_deployment]
#   name                = "${var.pipeline_name}-trigger-schedule"
#   data_factory_name   = azurerm_data_factory.az_data_factory.name
#   resource_group_name = azurerm_data_factory.az_data_factory.resource_group_name
#   pipeline_name       = azurerm_data_factory_pipeline.data_factory_pipeline_01.name

#   interval   = 1
#   frequency  = "Day"
# }

// azure authentication variables
variable "subscription_id" {
  type        = string
  description = "Defines the Azure Subscription ID"
}

variable "service_principal_object_id" {
  description = "Object ID of the existing service principal that will be used for communication between services"
  type        = string
}

variable "client_id" {
  type        = string
  description = "Client ID of the existing service principal that will be used for communication between services"
}

variable "client_secret" {
  type        = string
  description = "Client secret of the existing service principal that will be used for communication between services"
}

variable "tenant_id" {
  type        = string
  description = "Defines the Azure Tenant ID"
}

variable "dataset_input_name" {
  type        = string
  description = "Defines the dataset input name"
}

variable "dataset_output_name" {
  type        = string
  description = "Defines the dataset output name"
}

variable "input_test_file" {
  type        = string
  description = "Defines the data file"
}

variable "input_folder" {
  type        = string
  description = "Defines the input folder"
}

variable "output_folder" {
  type        = string
  description = "Defines the output folder"
}

variable "rg_suffix" {
  type        = string
  description = "Defines the resource group suffix"
}

variable "resource_group_location" {
  type        = string
  description = "Defines the resource group location"
}

variable "env" {
  type        = string
  description = "Defines the environment suffix"
}

variable "environment" {
  type        = string
  description = "Defines the Environment"
}


variable "project" {
  type        = string
  description = "Defines the project name"
}

variable "container_access_type" {
  type        = string
  description = "Defines the storage container access type"
}

variable "sc_suffix" {
  type        = string
  description = "Defines the storage container suffix"
}

variable "df_suffix" {
  type        = string
  description = "Defines the data factory suffix"
}

variable "app_sp_suffix" {
  type        = string
  description = "Defines the application service principal suffix"
}

variable "sa_suffix" {
  type        = string
  description = "Defines the storage account suffix"
}

variable "sa_account_tier" {
  type        = string
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
}

variable "sa_access_tier" {
  type        = string
  description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid."
}

variable "sa_account_replication_type" {
  type        = string
  description = "Select LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS"
}

variable "sa_account_kind" {
  type        = string
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
}

variable "sa_is_hns_enabled" {
  type        = bool
  description = "This can be used with Azure Data Lake Storage Gen 2"
}

variable "sku_name" {
  type        = string
  description = "Select Standard or Premium SKU"
}

variable "kv_template_deployment" {
  type        = bool
  description = "Allow Azure Virtual Machines to retrieve certificates stored as secrets from the Azure Key Vault"
}
variable "kv_disk_encryption" {
  type        = bool
  description = "Allow Azure Disk Encryption to retrieve secrets from the Azure Key Vault and unwrap keys"
}
variable "kv_vm_deployment" {
  type        = bool
  description = "Allow Azure Resource Manager to retrieve secrets from the Azure Key Vault"
}

variable "kv_key_permissions_full" {
  type    = list(string)
  description = "List of full key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey."
  default = []
}

variable "kv_secret_permissions_full" {
  type    = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default = []
}

variable "kv_certificate_permissions_full" {
  type    = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"  
  default = []
}

variable "kv_storage_permissions_full" {
  type    = list(string)
  description = "List of full storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default = []
}

variable "kv_key_permissions_read" {
  type    = list(string)
  description = "List of read key permissions, must be one or more from the following: backup, create, decrypt, delete, encrypt, get, import, list, purge, recover, restore, sign, unwrapKey, update, verify and wrapKey"
  default = []
}

variable "kv_secret_permissions_read" {
  type    = list(string)
  description = "List of full secret permissions, must be one or more from the following: backup, delete, get, list, purge, recover, restore and set"
  default = []
}

variable "kv_certificate_permissions_read" {
  type    = list(string)
  description = "List of full certificate permissions, must be one or more from the following: backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers and update"
  default = []
}

variable "kv_storage_permissions_read" {
  type    = list(string)
  description = "List of read storage permissions, must be one or more from the following: backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas and update"
  default = []
}

variable "kv_suffix" {
  type        = string
  description = "Defines the Key Vault suffix"
}

variable "pipeline_name" {
  type        = string
  description = "Defines the Pipeline name"
}

variable "activity_name" {
  type        = string
  description = "Defines the Pipeline Activity name"
}

variable "role_definition_owner" {
  type = string
  description = "Defines the Azure rol for blobs and queues - Storage Blob Data Owner"
}

variable "role_definition_contributor" {
  type = string
  description = "Defines the Azure rol for blobs and queues - Storage Blob Data Contributor"
}

variable "storage_blob_type" {
  type = string
  description = "Possible values are Append, Block or Page"
}

variable "identity_type" {
  type = string
  description = "Specifies the identity type of the Data Factory. At this time the only allowed value is SystemAssigned"
}

variable "linked_service_df_kv_name" {
  type = string
  description = "Defines the name of linked service between data factory and key vault"
}

variable "linked_service_df_bs_name" {
  type = string
  description = "Defines the name of linked service between data factory and blob storage"
}
variable "linked_service_ds_adls_name" {
  type = string
  description = "Defines the name of linked service between data factory and azure data lake store"
}

variable "column_delimiter" {
  type = string
  description = "Defines the column delimiter"
}

variable "row_delimiter" {
  type = string
  description = "Defines the row delimiter"
}

variable "encoding" {
  type = string
  description = "Defines the encoding"
}

variable "quote_character" {
  type = string
  description = "Defines the quote character"
}

variable "escape_character" {
  type = string
  description = "Defines the escape character"
}

variable "first_row_as_header" {
  type = bool
  description = "Defines first row as header"
}

variable "null_value" {
  type = string
  description = "Defines a NULL value"
}

variable "deployment_mode" {
  type = string
  description = "Specifies the mode that is used to deploy resources. This value could be either Incremental or Complete."
}

variable "network_acls_default_action" {
  type = string
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny."
}

variable "network_acls_bypass" {
  type = string
  description = "Specifies which traffic can bypass the network rules. Possible values are AzureServices and None."
}

variable "storage_key_name" {
  type = string
  description = "Defines the key vault name."
}

variable "storage_auth_mode" {
  type = string
  description = "Defines the authentication mode {key, login}."
}

variable "storage_acl" {
  type = string
  description = "POSIX access control rights on files and directories in the format [scope:][type]:[id]:[permissions]. e.g. user::rwx,group::r--,other::---,mask::rwx"
}

variable "account_name" {
  type    = string
  description = "Defines the git account name."
}

variable "branch_name" {
  type    = string
  description = "Defines the git branch name."
}

variable "git_url" {
  type    = string
  description = "Defines the git url."
}

variable "repository_name" {
  type    = string
  description = "Defines the git repository name."
}




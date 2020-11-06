// azure authentication variables - secrets!!!
//Auth
env                     = "test"
environment             = "Test"
project                 = "datadriversproj"
container_access_type   = "private"
sc_suffix               = "storage-container"
rg_suffix               = "rg"
resource_group_location = "westeurope"
app_sp_suffix           = "SP"

//Storage account
sa_suffix                    = "sa"
sa_account_tier              = "Standard"
sa_access_tier               = "Cool"
sa_account_replication_type  = "LRS"
sa_account_kind              = "StorageV2"
sa_is_hns_enabled            = true
storage_key_name             = "storage-account-secret-key"
role_definition_owner        = "Storage Blob Data Owner"
role_definition_contributor  = "Storage Blob Data Contributor"
identity_type                = "SystemAssigned"
storage_blob_type            = "Block"
storage_auth_mode            = "key"
storage_acl                  = "user::rwx,group::rwx,other::rwx"
network_acls_default_action  = "Allow"
network_acls_bypass          = "AzureServices"

//Key Vault
sku_name                        = "standard"
kv_vm_deployment                = true
kv_disk_encryption              = true
kv_template_deployment          = true
kv_suffix                       = "kv33"
kv_key_permissions_full         = ["backup", "create", "decrypt", "delete", "encrypt", "get", "import", "list", "purge", "recover", "restore", "sign", "unwrapKey", "update", "verify", "wrapKey"]
kv_secret_permissions_full      = ["backup", "delete", "get", "list", "purge", "recover", "restore", "set"]
kv_certificate_permissions_full = ["create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "purge", "recover", "setissuers", "update", "backup", "restore"]
kv_storage_permissions_full     = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "purge", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
kv_key_permissions_read         = ["get", "list"]
kv_secret_permissions_read      = ["get", "list"]
kv_certificate_permissions_read = ["get", "getissuers", "list", "listissuers"]
kv_storage_permissions_read     = ["get", "getsas", "list", "listsas"]


//Data Factory
df_suffix                    = "df"
dataset_input_name           = "DatasetInput"
dataset_output_name          = "DatasetOutput"
input_test_file              = "testdaten-uk-500.csv"
input_folder                 = "Inputs"
output_folder                = "Outputs"
linked_service_df_kv_name    = "AzureDataFactoryKeyVault"
linked_service_df_bs_name    = "LinkedService"
linked_service_ds_adls_name  = "lsdsadls"
pipeline_name                = "dfpipelinetest01"
activity_name                = "Copy files from ADLSGen to ADLSGen"

column_delimiter    = ","
row_delimiter       = "\r"
encoding            = "UTF-8"
quote_character     = "\""
escape_character    = "\\"
first_row_as_header = true
null_value          = "NULL"
deployment_mode     = "Incremental"

//github_configuration
account_name    = "devopsk8s"
branch_name     = "adf_test"
git_url         = "https://github.com"
repository_name = "project-datadrivers"

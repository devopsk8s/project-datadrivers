# IaaC Terraform (Azure)
- This project using Terraform deploys an Infrastructure with ADLS Gen2, Key Vault, Data Factory and Datasets on Microsoft Azure.
- A '.csv' file with test data will be created in the Input folder of a 'Azure Data Lake Storage Gen2' container. 
- The first row of the table will be changed using Azure Data Factory Pipeline.
- The linked services in the Azure Data Factory will use a Key Vault.
- The Output file will be generated in the Output folder of a 'Azure Data Lake Storage Gen2' container.
- Power BI will connect to Azure Data Lake Store Gen2 to access the output file.


## Prerequisities
- A subscription ID in Azure
- Create an Azure Service Connection to Azure Portal in Azure Devops using Azure Resource Manager (Subscription ID).
- In your subscription scope in Azure Portal, assign `Owner` rights to the service principal of the created azure devops service connection  (https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)
- Use git clone command or fork the repository in Github.
- Create a service connection in Azure Devops to Github repository (https://github.com/settings/tokens).
- Install the apps mentioned in the point 4.
- Create a new pipeline in Azure DevOps and use the existing "azure-iaac-pipeline.yml".
- Set the secret values in the Azure DevOps pipeline variables.
- Set as service_principal_object_id the `objectId` value from point 2.
- Set the environment and the backend variables.
- The "azure-iaac-pipeline.yml" will set up the Infrastructure in Azure.
- A change in the main branch will trigger a pipeline in Azure DevOps.


1. login to azure and set correct subscription
```
az login -u <your AAD credentials>
az account set --subscription <subscription in>
```

2. login to azure and set correct subscription
```
az ad sp list --filter "displayName eq 'displayName from Active Directory RegisteredApps'" 
    "objectId": "00000000-0000-0000-0000-000000000000",
    "objectType": "ServicePrincipal",
```


3. set the secret values to run it locally
```
Azure DevOps Variables:
subscription_id             = <subscription_id>
client_id                   = <client_id>
client_secret               = <client_secret>
tenant_id                   = <tenant_id>
service_principal_object_id = <service_principal_object_id>

Powershell:
$env:ARM_SUBSCRIPTION_ID=<SUBSCRIPTION_ID>
$env:ARM_TENANT_ID="_TENANT_ID"
$env:ARM_CLIENT_ID="CLIENT_ID" 
$env:ARM_CLIENT_SECRET="CLIENT_SECRET"

Unix:
export ARM_SUBSCRIPTION_ID=<SUBSCRIPTION_ID>
export ARM_TENANT_ID="_TENANT_ID"
export ARM_CLIENT_ID="CLIENT_ID" 
export ARM_CLIENT_SECRET="CLIENT_SECRET"
```

4. install the following apps for azure pipelines from azure marketplace 
```
Terraform 1 (https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)
Terraform 2 (https://marketplace.visualstudio.com/items?itemName=charleszipp.azure-pipelines-tasks-terraform)
```

5. commands to run terraform locally 
```
terraform init
terraform validate
terraform plan --var-file=env/<environment>/variables.tfvars --var-file=secrets/secrets.tfvars -out="<environment>.tfplan"
terraform apply "<env>.tfplan"
terraform destroy --var-file=env/<environment>/variables.tfvars --var-file=secrets/secrets.tfvars #-auto-approve
```

6. once the "terraform apply" task is finished, run the pipeline prepared by terrafrom in azure data factory to generate the output file.
```
Data Factory -> Factory Resources -> Pipelines -> dfpipelineXXX -> Trigger

Output folder -> is defined in the output dataset.
```

7. search for the values generated in the outputs (azure devops pipeline) 
```
terraform console
> storage_account_name
> storage_account_primary_access_key
> storage_account_primary_dfs_endpoint
```

8. using the previous values, open Power BI and connect to Azure ADLS Gen2 (Get Data/Daten abrufen) to open the file.


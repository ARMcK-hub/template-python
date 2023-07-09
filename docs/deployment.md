# Azure Deployment
The Microsoft Azure deployment found here utilizes Terraform to deploy the Container App and all associated resources.

The deployment templates can be found in [/ci/terraform/](../ci/terraform/) directory.

### Deployment Configuration:
For applications to work as expect, please ensure the following items are configured properly for your project:
- App [Dockerfile](../snek_case/Dockerfile) executes the proper entry point corresponse with the Port identified in the [Container App Deployment Ingess](../ci/terraform/container_app.tf)
- [Terraform locals](../ci/terraform/variables.tf) are set up properly for your project

In order to deploy, perform the following Standard terraform Steps:

> Note: it is recommended that you perform these steps inside of the dev container, as it has been configured to mount the host docker service.

### Deploy via Terraform calling script:

1. Execute the calling script and allow it to handle the initialization and deployment.
```
./deploy-terraform.sh \
    -n applicationName \
    -t <azure-tenant-id> \
    -s <azure-sub-id> \
    -r rg-for-terraform-storage-account \
    -a storage-account-for-terraform-state \
    -e prod \
    -l eastus
```

### Deploy directly via Terraform API:
1. Change Directory to the Terraform CI Folder:  
`cd ./ci/terraform`

2. Initialize Terraform to install the providers:  
```
terraform init \  
    -backend-config="resource_group_name=rg-name-here" \  
    -backend-config="storage_account_name=staccountname"  
```

> Note:  
    This template is set up for an azurerm backend. You can change the backend as prefered.
    See Docs: https://developer.hashicorp.com/terraform/language/settings/backends/local

3. Perform Terraform Apply:  
`terraform apply -var-file="secrets.tfvars"`

where `secrets.tfvars` includes at least the following required variables:  

```
tenant_id       = <azure-tenant-id>
subscription_id = <azure-sub-id>
```

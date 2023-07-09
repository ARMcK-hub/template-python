#!/bin/bash

# constants
blue='\e[0;34m'
red='\e[0;31m'
nocolor='\e[0m'
indent="     "


#####  OPTARG PARSING  #####
# terminal help function, exits script after execution
helpFunction()
{
   echo ""
   echo "Usage: $0 -n myapp -t <az-tenant-id> -s <az-sub-id> -r rg-admin -a stadmin -e prod -l eastus"
   echo -e "\t-n    Name of the application. Must contain only alpha characters."
   echo -e "\t-t    Azure Tenant ID to deploy to."
   echo -e "\t-s    Azure Subscription ID to deploy to."
   echo -e "\t-r    Azure Storage Account Resource Group name for Terraform backend."
   echo -e "\t-a    Azure Storage Account name for Terraform backend."
   echo -e "\t-e    (Optional) Name of the deployed environment. Must contain only alpha characters. Default: prod"
   echo -e "\t-l    (Optional) Location of the deployed environment. Default: eastus"
   echo ""
   exit 1
}

# acquiring opts, prints helpFunction in case parameter is non-existent
while getopts "n:t:s:r:a:e:l:" opt
do
    case "$opt" in
        n ) application="$OPTARG" ;;
        t ) tenantId="$OPTARG" ;;
        s ) subscriptionId="$OPTARG" ;;
        r ) resourceGroupName="$OPTARG" ;;
        a ) stroageAccountName="$OPTARG" ;;
        e ) environment="$OPTARG" ;;
        l ) location="$OPTARG" ;;
        ? ) helpFunction ;;
    esac
done

##### Variable Override and Validation #####
if [ -z $environment ]; then environment=prod; fi
if [ -z $location ]; then location=eastus; fi

# Print helpFunction in case parameters are empty
if [ -z "$application" ] || [ -z "$tenantId" ] || [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$stroageAccountName" ] 
then
   echo -e "${indent}${red}Some or all of the parameters are empty${nocolor}";
   helpFunction
fi


##### Script #####

cd ./terraform

# configure backend based on environment
terraform init \
    -backend-config="resource_group_name=${resourceGroupName}" \
    -backend-config="storage_account_name=${stroageAccountName}" \
    -backend-config="key=/${application}/${environment}.tfstate" \
    -reconfigure

terraform apply \
    -var="tenant_id=${tenantId}" \
    -var="subscription_id=${subscriptionId}" \
    -var="environment=${environment}" \
    -var="location=${location}"
    # -auto-approve

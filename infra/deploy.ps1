param (
    [string]$subscription_id,
    [string]$dns_subscription_id,
    [string]$environment = "dev",
    [string]$vnet_id,
    [string]$data_subnet_id,
    [string]$runtime_subnet_id,
    [switch]$y
)

$ErrorActionPreference = "Stop"

function Run-Command {
    param (
        [scriptblock]$command
    )
    & $command
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

# Set variables for storage account
$projectName = "ai-review-bot"
$location = "westeurope"
$resourceGroupName = "$projectName-terraform-state-rg"
$storageAccountName = "$($projectName.Replace('-', '').Substring(0, 10))$($environment.Substring(0, 3))state"
$containerName = "tfstate"

# Set the subscription
Run-Command { az account set --subscription $subscription_id }

# Create resource group
Run-Command { az group create --name $resourceGroupName --location $location }

# Create storage account
Run-Command { az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS }

# Get storage account key
$storageAccountKey = az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query '[0].value' --output tsv
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Create blob container
Run-Command { az storage container create --name $containerName --account-name $storageAccountName --account-key $storageAccountKey }

# Initialize Terraform with backend configuration
Run-Command {
    terraform init -backend-config="storage_account_name=$storageAccountName" `
                   -backend-config="container_name=$containerName" `
                   -backend-config="key=$environment.terraform.tfstate" `
                   -backend-config="access_key=$storageAccountKey"
}

# Plan Terraform configuration
Run-Command {
    terraform plan -var "subscription_id=$subscription_id" `
                   -var "dns_subscription_id=$dns_subscription_id" `
                   -var "environment=$environment" `
                   -var "vnet_id=$vnet_id" `
                   -var "data_subnet_id=$data_subnet_id" `
                   -var "runtime_subnet_id=$runtime_subnet_id"
}

if (-not $y) {
    $confirmation = Read-Host "Do you want to proceed with apply? (yes/no)"
    if ($confirmation -ne "yes") {
        Write-Host "Apply cancelled."
        exit
    }
}

# Apply Terraform configuration
Run-Command {
    terraform apply -auto-approve -var "subscription_id=$subscription_id" `
                                 -var "dns_subscription_id=$dns_subscription_id" `
                                 -var "environment=$environment" `
                                 -var "vnet_id=$vnet_id" `
                                 -var "data_subnet_id=$data_subnet_id" `
                                 -var "runtime_subnet_id=$runtime_subnet_id"
}

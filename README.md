# az-demo-terraform

Demo CheckMK site in Azure with Terraform.

## Azure Login

```console
$ az login
A web browser has been opened at https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize. Please continue the login in the web browser. If no web browser is available or if the web browser fails to open, use device code flow with `az login --use-device-code`.
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "10********c9",
    "id": "e6********ce",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Azure subscription 1",
    "state": "Enabled",
    "tenantId": "10********c9",
    "user": {
      "name": "xantara-it@protonmail.com",
      "type": "user"
    }
  }
]
```
## Azure account

Check if the account is correct.

```console
$ az account show
{
  "environmentName": "AzureCloud",
    "homeTenantId": "10********c9",
    "id": "e6********ce",
  "isDefault": true,
  "managedByTenants": [],
  "name": "Azure subscription 1",
  "state": "Enabled",
    "tenantId": "10********c9",
  "user": {
    "name": "xantara-it@protonmail.com",
    "type": "user"
  }
}
```

## Azure storage account name

Lookup the storage account name.

```console
$ az storage account list --resource-group xantara-it-rg --query '[0].name' --out tsv
xantarait********
```

N.B. The storage account is created with the Terraform code in the GitHub
[Xantara-it/az-remote-state](https://github.com/Xantara-it/az-remote-state)
repository.
This Terraform code must be executed only once to create the
storage account.

## Edit `access_key.sh`

Store the found storage account name variable.

```bash
#
# Save access key in an environment variable for Terraform remote state.
#
# $ az storage account list --resource-group xantara-it-rg --output table
#

RESOURCE_GROUP_NAME=xantara-it-rg
STORAGE_ACCOUNT_NAME=xantarait********

export ARM_ACCESS_KEY=$(az storage account keys list --resource-group ${RESOURCE_GROUP_NAME} --account-name ${STORAGE_ACCOUNT_NAME} --query '[0].value' -o tsv)
```

Source the script to store the `access key`.

```console
$ source ./access_key.sh
```

## Terraform init

```console
$ terraform init

Initializing the backend...

Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching ">= 3.17.0"...
- Installing hashicorp/azurerm v3.44.1...
- Installed hashicorp/azurerm v3.44.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

```console
$ terraform plan --out terraform.tfplan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # azurerm_public_ip.ip will be created
  + resource "azurerm_public_ip" "ip" {
      + allocation_method       = "Static"
      + ddos_protection_mode    = "VirtualNetworkInherited"
      + fqdn                    = (known after apply)
      + id                      = (known after apply)
      + idle_timeout_in_minutes = 4
      + ip_address              = (known after apply)
      + ip_version              = "IPv4"
      + location                = "westeurope"
      + name                    = "az-demo-ip"
      + resource_group_name     = "az-demo-rg"
      + sku                     = "Standard"
      + sku_tier                = "Regional"
      + tags                    = {
          + "createdby"   = "terraform"
          + "environment" = "demo"
        }
    }

  # azurerm_resource_group.rg will be created
  + resource "azurerm_resource_group" "rg" {
      + id       = (known after apply)
      + location = "westeurope"
      + name     = "az-demo-rg"
      + tags     = {
          + "createdby"   = "terraform"
          + "environment" = "demo"
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + public_ip = (known after apply)

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: terraform.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "terraform.tfplan"
```

## Terraform apply

```console
$ terraform apply terraform.tfplan
azurerm_resource_group.rg: Creating...
azurerm_resource_group.rg: Creation complete after 2s [id=/subscriptions/e6********ce/resourceGroups/az-demo-rg]
azurerm_public_ip.ip: Creating...
azurerm_public_ip.ip: Creation complete after 4s [id=/subscriptions/e6********ce/resourceGroups/az-demo-rg/providers/Microsoft.Network/publicIPAddresses/az-demo-ip]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:

public_ip = "52.233.246.226"
```
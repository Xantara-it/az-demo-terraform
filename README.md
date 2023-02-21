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

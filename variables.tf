variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Name prefix"
  default     = "demo"
}

variable "name_vm" {
  description = "Name vm"
  default     = "demo"
}

variable "name_user" {
  description = "Name admin user"
  default     = "xantara"
}

variable "rhsm_username" {
  default = ""
}

variable "rhsm_password" {
  default = ""
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "demo",
    "createdby"   = "terraform"
  }
}

# See: https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
#
# Size          CPU Mem
# Standard_B1ls 1   0.5
# Standard_B1s  1   1
# Standard_B1ms 1   2
# Standard_B2s  2   4
variable "linux_vm_size" {
  type        = string
  description = "Virtual machine size"
  default     = "Standard_B2s"
}

variable "linux_vm_count" {
  type    = number
  default = 0
}

variable "linux_vm_storage_account_type" {
  type        = string
  description = "Virtual machine storage account type"
  default     = "Standard_LRS"
}

variable "linux_vm_storage_size_gb" {
  type        = string
  description = "Virtual machine storage size in GiB"
  default     = "64"
}

variable "linux_vm_plan" {
  type = object({
    publisher = string
    product   = string
    name      = string
  })
  default = {
    publisher = "RedHat"
    product   = "rhel-byos"
    name      = "rhel-lvm86-gen2"
  }
}

variable "linux_vm_gallery_image" {
  type = object({
    resource_group = string
    gallery        = string
    name           = string
    version        = string
  })
  default = {
    resource_group = "gallery-rg"
    gallery        = "gallery"
    name           = "xan-cmk-demo"
    version        = "recent"
  }
}

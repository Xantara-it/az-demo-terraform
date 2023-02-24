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

#
# az vm image list --publisher RedHat --offer rhel-byos --all --out table
#
variable "linux_vm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "RedHat"
}

variable "linux_vm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "rhel-byos"
}

variable "linux_vm_image_sku" {
  type        = string
  description = "SKU for RHEL 8.7 Gen2"
  default     = "rhel-lvm86-gen2"
}

variable "linux_vm_image_id" {
  type        = string
  description = "Virtual machine custom image id"
  default     = ""
}

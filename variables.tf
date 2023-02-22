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

variable "linux_vm_image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "RedHat"
}

variable "linux_vm_image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "RHEL"
}

variable "linux_vm_image_sku" {
  type        = string
  description = "SKU for RHEL 8.7 Gen2"
  default     = "87-gen2"
}


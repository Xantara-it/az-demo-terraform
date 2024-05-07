variable "vm_name" {
  description = "Name vm"
}

variable "vm_prefix" {
  description = "Name prefix"
}

variable "vm_count" {
  type    = number
  default = 0
}

variable "vm_user" {
  description = "Name admin user"
  default     = "xantara"
}

variable "vm_pubkey" {
  type    = string
  default = null
}

variable "vm_custom_data" {
  type    = string
  default = ""
}

variable "vm_image_info" {
  type    = any
  default = null
}

variable "vm_plan" {
  type    = any
  default = null
}

variable "vm_rg_id" {
  type = string
}

variable "vm_subnet_id" {
  type = string
}

variable "vm_sg_id" {
  type = string
}

# See: https://learn.microsoft.com/en-us/azure/virtual-machines/sizes-b-series-burstable
#
# Size          CPU Mem
# Standard_B1ls 1   0.5
# Standard_B1s  1   1
# Standard_B1ms 1   2
# Standard_B2s  2   4
variable "vm_size" {
  type        = string
  description = "Virtual machine size"
  default     = "Standard_B2s"
}

variable "vm_storage_account_type" {
  type        = string
  description = "Virtual machine storage account type"
  default     = "Standard_LRS"
}

variable "vm_storage_size_gb" {
  type        = string
  description = "Virtual machine storage size in GiB"
  default     = "64"
}

variable "vm_tags" {
  type = map(any)
}

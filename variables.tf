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

variable "rhsm_username" {
  default = ""
}

variable "rhsm_password" {
  default = ""
}

variable "rhsm_pool" {
  default = ""
}

variable "linux_vm_count" {
  type    = number
  default = 0
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "demo",
    "createdby"   = "terraform"
  }
}

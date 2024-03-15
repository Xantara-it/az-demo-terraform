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

variable "tags" {
  type = map(any)
  default = {
    "environment" = "demo",
    "createdby"   = "terraform"
  }
}

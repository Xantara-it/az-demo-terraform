variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "whitelist_ips" {
  default = [
    "83.83.20.30",    # gerlof
    "87.247.91.93",
    "95.128.91.242",
    "104.40.150.102", # caner
    "217.100.42.38",  # xantara
  ]
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

variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Name prefix"
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

variable "tags" {
  type = map(any)
  default = {
    "environment" = "demo",
    "createdby"   = "terraform"
  }
}

variable "whitelist_ips" {
  default = [
    "87.247.91.93",   # gerlof
    "188.90.165.208", # gerlof
    "217.100.42.38",  # xantara
  ]
}

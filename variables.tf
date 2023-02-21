variable "location" {
  description = "Location of the Azure Cloud"
  default     = "westeurope"
}

variable "name_prefix" {
  description = "Name prefix"
  default     = "az-demo"
}

variable "tags" {
  type = map(any)
  default = {
    "environment" = "demo",
    "createdby"   = "terraform"
  }
}

output "public_ip" {
  value = azurerm_public_ip.ip.ip_address
}

# terraform output password
output "password" {
  value     = random_password.password.result
  sensitive = true
}

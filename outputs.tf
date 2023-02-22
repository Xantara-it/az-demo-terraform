output "public_ip" {
    value = azurerm_public_ip.ip.ip_address
}

# terraform output password
output "password" {
  value = random_password.password.result
  sensitive = true
}

# terraform output -raw tls_private_key > id_rsa
# chmod 400 id_rsa
# ssh -i id_rsa -l azureuser ${public_ip}
output "tls_private_key" {
  value     = tls_private_key.private_ssh_key.private_key_pem
  sensitive = true
}

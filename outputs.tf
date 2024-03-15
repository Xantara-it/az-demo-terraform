output "cmk_public_ip" {
  value = module.vm_cmk.public_ip
}

# terraform output password
output "cmk_password" {
  value     = module.vm_cmk.password
  sensitive = true
}

output "db_public_ip" {
  value = module.vm_rhel.public_ip
}

output "db_password" {
  value     = module.vm_rhel.password
  sensitive = true
}

# terraform output -raw tls_private_key > id_rsa
# chmod 400 id_rsa
output "tls_private_key" {
  value     = tls_private_key.private_ssh_key.private_key_pem
  sensitive = true
}

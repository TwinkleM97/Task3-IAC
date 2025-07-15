output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.web.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.web.private_ip
}

output "private_key_pem" {
  description = "Private key to SSH into EC2 instance"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}
output "deployer_private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
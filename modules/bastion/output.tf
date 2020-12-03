output "id" {
  description = "Instance ID of Bastion"
  value       = aws_instance.bastion.id
}

output "public_ip" {
  description = "Public IP of bastion"
  value       = aws_instance.bastion.public_ip
}

output "private_ip" {
  description = "Private IP of bastion"
  value       = aws_instance.bastion.private_ip
}

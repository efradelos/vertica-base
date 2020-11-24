output "management_ip" {
  description = "Public IP of Managment Console"
  value       = aws_instance.management[0].public_ip
}

output "node_ips" {
  description = "List of private ips of nodes"
  value       = aws_instance.nodes.*.private_ip
}

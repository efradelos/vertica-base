output "ids" {
  description = "List of node ids"
  value       = aws_instance.nodes.*.id
}

output "public_ips" {
  description = "List of public ips of nodes"
  value       = aws_instance.nodes.*.public_ip
}

output "private_ips" {
  description = "List of private ips of nodes"
  value       = aws_instance.nodes.*.private_ip
}

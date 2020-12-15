output "ids" {
  description = "List of node ids"
  value       = concat([aws_instance.primary_node.id], aws_instance.secondary_nodes.*.id)
}

output "public_ips" {
  description = "List of public ips of nodes"
  value       = concat([aws_instance.primary_node.public_ip], aws_instance.secondary_nodes.*.public_ip)
}

output "private_ips" {
  description = "List of private ips of nodes"
  value       = concat([aws_instance.primary_node.private_ip], aws_instance.secondary_nodes.*.private_ip)
}

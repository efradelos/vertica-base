output "node_ids" {
  description = "List of node ids"
  value       = module.vertica_nodes.ids
}

output "node_public_ips" {
  description = "List of public ips of nodes"
  value       = module.vertica_nodes.public_ips
}

output "node_private_ips" {
  description = "List of private ips of nodes"
  value       = module.vertica_nodes.private_ips
}

output "lb_dns_name" {
  description = "DNS Name of Load Balancer"
  value       = module.lb.*.dns_name
}

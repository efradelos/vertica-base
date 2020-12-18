output "vpc_id" {
  description = "ID of VPC to install vertica cluster"
  value       = var.vpc_id
}

output "public_subnet_id" {
  description = "ID of public subnet to install vertica cluster. Used for bastion"
  value       = var.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of public subnet to install vertica cluster. Used for nodes"
  value       = var.private_subnet_id
}

output "ssh_key_name" {
  description = "Name of key pair to use for ssh"
  value       = var.ssh_key_name
}

output "security_group_name" {
  description = "Name of security group that allows traffic for vertica communication"
  value       = var.security_group_name
}

output "communal_storage_bucket" {
  description = "Name of s3 bucket to hold communal data"
  value       = var.communal_storage_bucket
}

output "mc_id" {
  description = "Management Console id"
  value       = var.create_mc ? aws_instance.management_console.0.id : ""
}

output "mc_public_ip" {
  description = "Public ip of Managment Console"
  value       = var.create_mc ? aws_instance.management_console.0.public_ip : ""
}

output "mc_private_ip" {
  description = "Private ip of Managment Console"
  value       = var.create_mc ? aws_instance.management_console.0.private_ip : ""
}

output "node_ids" {
  description = "List of node ids"
  value       = local.nodes.*.id
}

output "node_public_ips" {
  description = "List of public ips of nodes"
  value       = local.nodes.*.public_ip
}

output "node_private_ips" {
  description = "List of private ips of nodes"
  value       = local.nodes.*.private_ip
}

output "lb_dns_name" {
  description = "DNS Name of Load Balancer"
  value       = var.create_lb ? module.lb.0.this_lb_dns_name : ""
}

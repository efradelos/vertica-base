output "dns_name" {
  description = "DNS Name of load balancer"
  value       = aws_lb.lb.dns_name
}

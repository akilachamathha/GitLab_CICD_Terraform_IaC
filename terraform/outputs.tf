output "ecs_cluster_name" {
  value = aws_ecs_cluster.webapp.name
}

output "ecs_service_name" {
  value = aws_ecs_service.webapp.name
}

output "load_balancer_dns" {      # Output the DNS name of the load balancer
  value = aws_lb.alb.dns_name
}
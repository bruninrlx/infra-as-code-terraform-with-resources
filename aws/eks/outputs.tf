output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "health_check_url" {
  description = "URL for application health check."
  value       = "${module.eks.cluster_endpoint}/healthz"
}

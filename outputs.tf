output "service_name" {
  description = "Service name for Drone server deployment"
  value       = kubernetes_service.drone_server.metadata.0.name
}

output "service_http_port" {
  description = "HTTP port exposed by the service"
  value       = kubernetes_service.drone_server.spec.0.port.0.port
}

output "drone_runner_secret" {
  description = "Drone runner secret"
  value       = random_id.rpc_secret_key.hex
  sensitive   = true
}

output "instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.default.endpoint
}

output "instance_port" {
  description = "The database port"
  value       = aws_db_instance.default.port
}
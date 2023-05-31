output instance_id {
  value       = aws_instance.nginx_server.*.public_ip
  sensitive   = true
  description = "description"
  depends_on  = []
}

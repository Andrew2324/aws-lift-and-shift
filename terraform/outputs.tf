output "instance_public_ip" {
  description = "Public IP of the migrated (lifted) EC2 instance"
  value       = aws_instance.legacy_app.public_ip
}

output "http_url" {
  description = "HTTP URL to test the app"
  value       = "http://${aws_instance.legacy_app.public_ip}"
}

output "ssh_command" {
  description = "Example SSH command (adjust username if needed)"
  value       = "ssh -i <path-to-your-key.pem> ec2-user@${aws_instance.legacy_app.public_ip}"
}

output "instance_id" {
  value = aws_instance.legacy_app.id
}

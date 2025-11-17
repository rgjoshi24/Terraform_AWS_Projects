output "public_ip" {
  description = "EC2 public IP"
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "EC2 public DNS"
  value       = aws_instance.web.public_dns
}

output "site_url" {
  description = "URL for the NGINX page"
  value       = "http://${aws_instance.web.public_dns}"
}

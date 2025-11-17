# Security Group allowing HTTP (and optional SSH)
resource "aws_security_group" "web" {
  name        = "aws-sg-${var.project_name}-web"
  description = "Allow HTTP; optional SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = var.allow_ssh && var.allowed_ssh_cidr != null ? [1] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

# IAM role/profile for SSM access
resource "aws_iam_role" "ec2" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" }, Action = "sts:AssumeRole" }] })
  tags               = local.tags
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-profile"
  role = aws_iam_role.ec2.name
}

# User data: run code to deploy NGINX + index.html
locals {
  user_data = <<-EOT
    #!/bin/bash
    set -euxo pipefail

    # Update packages and install nginx
    yum update -y
    amazon-linux-extras install nginx1 -y || yum install -y nginx

    # Enable and start nginx
    systemctl enable nginx
    systemctl start nginx

    # Write custom index.html
    cat > /usr/share/nginx/html/index.html <<'HTML'
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8"/>
        <title>Terraform NGINX Demo</title>
        <style>
          body { font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif; padding: 2rem; }
          .ok  { color: #0a7; }
        </style>
      </head>
      <body>
        <h1 class="ok">SIMPLE PROJECT TO CREATE AN AWS EC2 INSTANCE USING TERRAFORM AND INSTALL A WEBSERVER</h1>
      </body>
    </html>
    HTML

    # Ensure SSM agent is running (preinstalled on AL2)
    systemctl enable amazon-ssm-agent || true
    systemctl start amazon-ssm-agent || true
  EOT
}

# EC2 instance (Default VPC)
resource "aws_instance" "web" {
  ami                         = data.aws_ami.al2.id
  instance_type               = var.instance_type
  subnet_id                   = local.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  user_data                   = local.user_data
  user_data_replace_on_change = true
  key_name                    = null
  tags                        = local.tags
}

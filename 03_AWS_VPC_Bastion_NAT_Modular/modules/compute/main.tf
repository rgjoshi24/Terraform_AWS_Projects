
variable "public_subnet_id" { type = string }
variable "private_subnet_id" { type = string }
variable "bastion_sg_id" { type = string }
variable "private_sg_id" { type = string }
variable "key_name" { type = string }
variable "bastion_instance_type" { type = string }
variable "private_instance_type" { type = string }
variable "tags" { type = map(string) }

# AMI lookup
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter { 
    name = "name"                 
    values = ["al2023-ami-*-x86_64"] 
  }
  filter { 
    name = "virtualization-type"  
    values = ["hvm"] 
  }
  filter { 
    name = "root-device-type"     
    values = ["ebs"] 
  }
}

# Bastion EC2 (public)
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-bastion" })
}

# Private EC2 (private)
resource "aws_instance" "private_host" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.private_instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.key_name
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-private" })
}

output "bastion_public_ip" { value = aws_instance.bastion.public_ip }
output "private_host_private_ip" { value = aws_instance.private_host.private_ip }

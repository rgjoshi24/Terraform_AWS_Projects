
variable "vpc_id" { type = string }
variable "allowed_ssh_cidr" { type = string }
variable "tags" { type = map(string) }

# Bastion SG – SSH from your IP only
resource "aws_security_group" "bastion_sg" {
  name        = "${var.tags["Project"]}-bastion-sg"
  description = "Allow SSH from your IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from your IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags["Project"]}-bastion-sg" })
}

# Private SG – SSH only from Bastion SG
resource "aws_security_group" "private_sg" {
  name        = "${var.tags["Project"]}-private-sg"
  description = "Allow SSH from Bastion SG"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.tags["Project"]}-private-sg" })
}

resource "aws_security_group_rule" "private_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
  description              = "SSH from Bastion SG"
}

output "bastion_sg_id" { value = aws_security_group.bastion_sg.id }
output "private_sg_id" { value = aws_security_group.private_sg.id }

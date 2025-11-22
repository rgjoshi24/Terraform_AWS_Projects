
locals {
  common_tags = {
    Project       = var.project_name
    X-Environment = var.x_environment
    X-Customer    = var.x_customer
    X-Dept        = var.x_dept
    X-Contact     = var.x_contact
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, { Name = "${var.project_name}-public-subnet" })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az
  tags = merge(local.common_tags, { Name = "${var.project_name}-private-subnet" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-public-rt" })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-private-rt" })
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = merge(local.common_tags, { Name = "${var.project_name}-nat-eip" })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw]
  tags          = merge(local.common_tags, { Name = "${var.project_name}-nat-gw" })
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-bastion-sg"
  description = "Allow SSH from your IP"
  vpc_id      = aws_vpc.main.id
  ingress { 
    from_port = 22 
    to_port = 22 
    protocol = "tcp" 
    cidr_blocks = [var.allowed_ssh_cidr] 
    description = "SSH" 
  }
  egress  { 
    from_port = 0  
    to_port = 0  
    protocol = "-1"  
    cidr_blocks = ["0.0.0.0/0"] 
    }
  tags = merge(local.common_tags, { Name = "${var.project_name}-bastion-sg" })
}

resource "aws_security_group" "private_sg" {
  name        = "${var.project_name}-private-sg"
  description = "Allow SSH from Bastion SG"
  vpc_id      = aws_vpc.main.id
  egress  { 
    from_port = 0  
    to_port = 0  
    protocol = "-1"  
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = merge(local.common_tags, { Name = "${var.project_name}-private-sg" })
}

resource "aws_security_group_rule" "private_ssh_from_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private_sg.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

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

variable "bastion_instance_type" { 
  type = string 
  default = "t3.micro" 
}
variable "private_instance_type" { 
  type = string 
  default = "t3.micro" 
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.bastion_instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags = merge(local.common_tags, { Name = "${var.project_name}-bastion" })
}

resource "aws_instance" "private_host" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.private_instance_type
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = var.key_name
  tags = merge(local.common_tags, { Name = "${var.project_name}-private" })
}

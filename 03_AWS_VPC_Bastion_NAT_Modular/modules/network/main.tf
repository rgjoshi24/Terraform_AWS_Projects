
variable "vpc_id" { type = string }
variable "public_subnet_cidr" { type = string }
variable "private_subnet_cidr" { type = string }
variable "az" { type = string }
variable "tags" { type = map(string) }

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-igw" })
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-public-subnet" })
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-private-subnet" })
}

# Public RT
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.tags["Project"]}-public-rt" })
}

# Explicit default route to IGW
resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_internet_gateway.igw]
}

# Associate public RT
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private RT
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  tags   = merge(var.tags, { Name = "${var.tags["Project"]}-private-rt" })
}

# Associate private RT
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# EIP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-nat-eip" })
}

# NAT GW in public subnet
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw]
  tags          = merge(var.tags, { Name = "${var.tags["Project"]}-nat-gw" })
}

# Private default route via NAT
resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

output "public_subnet_id" { value = aws_subnet.public.id }
output "private_subnet_id" { value = aws_subnet.private.id }
output "internet_gateway_id" { value = aws_internet_gateway.igw.id }
output "nat_gateway_id" { value = aws_nat_gateway.nat.id }

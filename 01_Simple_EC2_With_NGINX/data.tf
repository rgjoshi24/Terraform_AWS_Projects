# Default VPC & subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Amazon Linux 2 AMI
data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  # This correctly accesses the list of IDs returned by the data source
  subnet_id = data.aws_subnets.default_vpc_subnets.ids[0]
  tags = {
    Name            = var.project_name
    Project         = var.project_name
    ManagedBy       = "Terraform"
    "X-Environment" = var.x_environment
    "X-Customer"    = var.x_customer
    "X-Dept"        = var.x_dept
    "X-Contact"     = var.x_contact
  }
}

# Note: Ensure you define the variables used in the 'locals' block (var.project_name, etc.)
# in a separate variables.tf file or provide their values when running terraform apply.

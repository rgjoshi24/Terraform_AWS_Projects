
variable "vpc_cidr" { type = string }
variable "tags" { type = map(string) }

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.tags["Project"]}-vpc" })
}

output "vpc_id" { value = aws_vpc.main.id }


variable "project_name" { 
    description = "Name tag prefix" 
    type = string 
    default = "tf-beginner-vpc" 
}
variable "region"       { 
    description = "AWS region"     
    type = string 
    default = "ca-central-1" 
}
variable "az"           { 
    description = "Availability Zone" 
    type = string 
    default = "ca-central-1a" 
}
variable "vpc_cidr"     { 
    description = "VPC CIDR"       
    type = string 
    default = "10.0.0.0/16" 
}
variable "public_subnet_cidr"  { 
    description = "Public subnet CIDR" 
    type = string 
    default = "10.0.1.0/24" 
}
variable "private_subnet_cidr" { 
    description = "Private subnet CIDR" 
    type = string 
    default = "10.0.2.0/24" 
}
variable "allowed_ssh_cidr" { 
    description = "Your public IP in CIDR (x.x.x.x/32)" 
    type = string 
    default = "default_cidr" 
}
variable "key_name" { 
    description = "Existing EC2 key pair name" 
    type = string 
    default = "default.pem" 
}

# Extra tag vars
variable "x_environment" { 
    type = string 
    default = "dev" 
}
variable "x_customer"    { 
    type = string 
    default = "Internal" 
}
variable "x_dept"        { 
    type = string 
    default = "Internal Project" 
}
variable "x_contact"     { 
    type = string 
    default = "test@example.com" 
}

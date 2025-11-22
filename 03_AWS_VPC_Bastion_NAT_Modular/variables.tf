
# Root variables for Project 03 (Modular)
variable "project_name" { 
    type = string 
    default = "tf-beginner-vpc-modular" 
}
variable "region"       { 
    type = string
    default = "ca-central-1" 
}
variable "az"           { 
    type = string 
    default = "ca-central-1a" 
}

# CIDRs
variable "vpc_cidr"            { 
    type = string 
    default = "10.0.0.0/16" 
}
variable "public_subnet_cidr"  { 
    type = string 
    default = "10.0.1.0/24" 
}
variable "private_subnet_cidr" { 
    type = string 
    default = "10.0.2.0/24" 
}

# Access & instances
variable "allowed_ssh_cidr" { 
    type = string 
    default = "10.0.0.6/32" 
}
variable "key_name"         { 
    type = string 
    default = "testaws" 
}
variable "bastion_instance_type" { 
    type = string 
    default = "t3.micro" 
}
variable "private_instance_type" { 
    type = string 
    default = "t3.micro" 
}

# Global tags
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

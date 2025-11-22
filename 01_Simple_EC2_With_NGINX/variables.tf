variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name/Project tag"
  type        = string
  default     = "simple-ec2-chef-nginx"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# Access toggles
variable "allow_ssh" {
  description = "Enable SSH (use SSM when false)"
  type        = bool
  default     = false
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed for SSH when enabled"
  type        = string
  default     = null
}

# Business tags (X-*)
variable "x_environment" {
  description = "Environment label (dev|stage|prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "stage", "prod"], var.x_environment)
    error_message = "x_environment must be one of: dev, stage, prod."
  }
}

variable "x_customer" {
  description = "Customer/owner"
  type        = string
  default     = "Internal"
}

variable "x_dept" {
  description = "Department/Cost center"
  type        = string
  default     = "Internal"
}

variable "x_contact" {
  description = "Contact email or Slack"
  type        = string
  default     = "test@example.com"
}

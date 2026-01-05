variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "il-central-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.20.0.0/16"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.20.1.0/24"
}

variable "onprem_cidr" {
  description = "On-prem / pfSense LAN"
  type        = string
  default     = "10.10.1.0/24"
}

variable "onprem_public_ip" {
  description = "Public IP of your pfSense (as seen by AWS, no /32)"
  type        = string
}

variable "vpn_psk" {
  description = "Pre-shared key for both VPN tunnels"
  type        = string
  sensitive   = true
}

variable "private_instance_ami" {
  description = "AMI ID for your private EC2 instance"
  type        = string
}

variable "private_instance_type" {
  description = "Instance type for private EC2"
  type        = string
  default     = "t3.micro"
}
################################################################################
#####     VARIABLES
################################################################################

variable "vpc_name" {
  description = "Name of new VPC"
  type        = string
}

variable "cidr_block" {
  description = "Network CIDR block assigned to new VPC"
  type        = string
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  type        = bool
  default     = false
}

variable "enable_classiclink" {
  description = "Enable/disable ClassicLink for the VPC"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "Whether or not the VPC has ClassicLink DNS Support"
  type        = bool
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
  type        = bool
  default     = false
}

variable "public_network_cidrs" {
  description = "Comma separated list of public network CIDRs"
  type        = string
  default     = ""
}

variable "public_availability_zones" {
  description = "Comma separated list of public network availability zones"
  type        = string
  default     = ""
}

variable "private_network_cidrs" {
  description = "Comma separated list of private network CIDRs"
  type        = string
  default     = ""
}

variable "private_availability_zones" {
  description = "Comma separated list of private network availability zones"
  type        = string
  default     = ""
}

variable "enable_nat_gateway" {
  description = "Whether or not NAT is provided by a NAT Gateway"
  type        = bool
  default     = false
}

variable "enable_nat_instance" {
  description = "Whether or not NAT is provided by an EC2 instance"
  type        = bool
  default     = true
}

variable "nat_instance_key_pair" {
  description = "The key name of the Key Pair to use for the NAT instance"
  type        = string
  default     = null
}

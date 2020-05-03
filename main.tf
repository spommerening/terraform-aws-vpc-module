################################################################################
#####     AWS VPC Definition & Internet Gateway
################################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = map(
    "Name", "${var.vpc_name}-${element(split(".", var.cidr_block), 0)}-${element(split(".", var.cidr_block), 1)}-${element(split(".", var.cidr_block), 2)}/${element(split("/", var.cidr_block), 1)}",
    "vpc_name", var.vpc_name
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_internet_gateway" "this" {
  count  = var.public_network_cidrs != "" ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = map(
    "Name", "igw-${var.vpc_name}-${element(split(".", var.cidr_block), 0)}-${element(split(".", var.cidr_block), 1)}-${element(split(".", var.cidr_block), 2)}/${element(split("/", var.cidr_block), 1)}",
    "vpc_name", var.vpc_name
  )
}

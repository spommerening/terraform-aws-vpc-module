# AWS VPC Terraform Module

Terraform module for creating VPC and network resources on AWS.

## Usage

```
module "vpc_01" {
  source                     = "./modules/vpc"
  vpc_name                   = "vpc-01"
  cidr_block                 = "10.240.0.0/21"
  enable_nat_instance        = true
  nat_instance_key_pair      = aws_key_pair.stefan_pommerening.key_name

  public_network_cidrs       = "10.240.0.0/24,10.240.1.0/24,10.240.2.0/24"
  public_availability_zones  = "eu-central-1a,eu-central-1b,eu-central-1c"
  private_network_cidrs      = "10.240.4.0/24,10.240.5.0/24,10.240.6.0/24"
  private_availability_zones = "eu-central-1a,eu-central-1b,eu-central-1c"
}
```

## Networks

This module creates both public and private subnets depending on input parameters. 
If no public or no private networks are require, leave the corresponding parameter
(`public_network_cidrs` or `private_network_cidrs`) empty. 
 
## NAT Scenarios

This module supports creating either a NAT gateway (AWS managed service), 
or a NAT instance (self managed instance based on Amazon NAT AMI).
Currently, all configurations provide only one single NAT instance or NAT gateway
even if the private subnets span different availability zones.
The foremost motivation was providing a Terraform VPC module for creating
low-cost network setups. The NAT instance is much cheaper than the NAT gateway, 
only instance cost applies. 

## Input Parameters

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vpc_name` | Name of new VPC | `string` | - |
| `cidr_block` | Network CIDR block assigned to new VPC | `string` | - |
| `instance_tenancy` | A tenancy option for instances launched into the VPC | `string` | `default` |
| `enable_dns_support` | Whether or not the VPC has DNS support | `bool` | `true` |
| `enable_dns_hostnames` | Whether or not the VPC has DNS hostname support | `bool` | `false` |
| `enable_classiclink` | Enable/disable ClassicLink for the VPC | `bool` | `false` |
| `enable_classiclink_dns_support` | Whether or not the VPC has ClassicLink DNS Support | `bool` | `false` |
| `assign_generated_ipv6_cidr_block` | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC | `bool` | `false` |
| `public_network_cidrs` | Comma separated list of public network CIDRs | `string` | `""` |
| `public_availability_zones` | Comma separated list of public network availability zones | `string` | `""` |
| `private_network_cidrs` | Comma separated list of private network CIDRs | `string` | `""` |
| `private_availability_zones` | Comma separated list of private network availability zones | `string` | `""` |
| `enable_nat_gateway` | Whether or not NAT is provided by a NAT Gateway | `bool` | `false` |
| `enable_nat_instance` | Whether or not NAT is provided by an EC2 instance | `bool` | `true` |
| `nat_instance_key_pair` | The key name of the Key Pair to use for the NAT instance | `string` | `null` |

## Outputs

| Name | Description |
|------|-------------|
| `vpc_id` | The ID of the VPC |
| `internet_gateway_id` | The ID of the internet gateway |
| `internet_gateway_owner_id` | The Owner ID of the internet gateway |
| `public_network_ids` | Array of public network ids |
| `public_network_route_table_ids` | Array of public network routing table ids |
| `private_network_ids` | Array of private network ids |
| `private_network_route_table_ids` | Array of private network routing table ids |
| `nat_gateway_ids` | Array of NAT gateway ids (if selected) |
| `nat_instance_ids` | Array of NAT instance ids (if selected |

## Author

This module is maintained by Stefan Pommerening.

## License

Apache 2 Licensed. See LICENSE for full details.

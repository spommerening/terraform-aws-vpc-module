################################################################################
#####     OUTPUTS
################################################################################

output "vpc_id" {
  value = aws_vpc.this.id
}

output "internet_gateway_id" {
  value = flatten(aws_internet_gateway.this.*.id)
}

output "internet_gateway_owner_id" {
  value = flatten(aws_internet_gateway.this.*.owner_id)
}

output "public_network_ids" {
  value = aws_subnet.public.*.id
}

output "public_network_route_table_ids" {
  value = aws_route_table.public.*.id
}

output "private_network_ids" {
  value = aws_subnet.private.*.id
}

output "private_network_route_table_ids" {
  value = aws_route_table.private.*.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.natgw.*.id
}

output "nat_instance_ids" {
  value = aws_instance.natgw.*.id
}

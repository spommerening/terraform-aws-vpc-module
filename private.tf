################################################################################
#####     PRIVATE NETWORKS
################################################################################

resource "aws_subnet" "private" {
  count             = var.private_network_cidrs != "" ? length(split(",", var.private_network_cidrs)) : 0
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(split(",", var.private_network_cidrs), count.index)
  availability_zone = element(split(",", var.private_availability_zones), count.index)

  tags = map(
    "Name", "${var.vpc_name}-private-${element(split(".", element(split(",", var.private_network_cidrs), count.index)), 0)}-${element(split(".", element(split(",", var.private_network_cidrs), count.index)), 1)}-${element(split(".", element(split(",", var.private_network_cidrs), count.index)), 2)}/${element(split("/", element(split(",", var.private_network_cidrs), count.index)), 1)}-${element(split("-", element(split(",", var.private_availability_zones), count.index)), 2)}",
    "vpc_name", var.vpc_name
  )

  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  count  = var.private_network_cidrs != "" ? length(split(",", var.private_network_cidrs)) : 0
  vpc_id = aws_vpc.this.id

  tags = map(
    "Name", "${var.vpc_name}-private",
    "vpc_name", var.vpc_name
  )
}

resource "aws_route_table_association" "private" {
  count          = var.private_network_cidrs != "" ? length(split(",", var.private_network_cidrs)) : 0
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Based on selection either create a route to NAT instance or NAT gateway
resource "aws_route" "private_nat_instance" {
  count                  = var.private_network_cidrs != "" && var.enable_nat_instance ? length(split(",", var.private_network_cidrs)) : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  instance_id            = aws_instance.natgw[0].id
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.private_network_cidrs != "" && var.enable_nat_gateway ? length(split(",", var.private_network_cidrs)) : 0
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[0].id
}

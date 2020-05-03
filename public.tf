################################################################################
#####     PUBLIC NETWORKS
################################################################################

resource "aws_subnet" "public" {
  count             = var.public_network_cidrs != "" ? length(split(",", var.public_network_cidrs)) : 0
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(split(",", var.public_network_cidrs), count.index)
  availability_zone = element(split(",", var.public_availability_zones), count.index)

  tags = map(
    "Name", "${var.vpc_name}-public-${element(split(".", element(split(",", var.public_network_cidrs), count.index)), 0)}-${element(split(".", element(split(",", var.public_network_cidrs), count.index)), 1)}-${element(split(".", element(split(",", var.public_network_cidrs), count.index)), 2)}/${element(split("/", element(split(",", var.public_network_cidrs), count.index)), 1)}-${element(split("-", element(split(",", var.public_availability_zones), count.index)), 2)}",
    "vpc_name", var.vpc_name
  )

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  count  = var.public_network_cidrs != "" ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name     = "${var.vpc_name}-public"
    vpc_name = var.vpc_name
  }
}

resource "aws_route" "public" {
  count                  = var.public_network_cidrs != "" ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = var.public_network_cidrs != "" ? length(split(",", var.public_network_cidrs)) : 0
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

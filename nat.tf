################################################################################
#####     NAT INSTANCE / NAT GATEWAY
################################################################################
#####     Reference for ICMP Code Fields (from_port parameter):
#####     http://www.iana.org/assignments/icmp-parameters/icmp-parameters.xhtml

resource "aws_security_group" "natsg" {
  count       = var.enable_nat_instance ? 1 : 0
  name        = "${var.vpc_name}-natsg"
  description = "Security group for NAT gateway"
  vpc_id      = aws_vpc.this.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ aws_vpc.this.cidr_block ]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 8     # echo
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ aws_vpc.this.cidr_block ]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ aws_vpc.this.cidr_block ]
  }

  ingress {
    from_port   = 8     # echo
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [ aws_vpc.this.cidr_block ]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name     = "${var.vpc_name}-natsg"
    vpc_name = var.vpc_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "natgw" {
  filter {
    name   = "name"
    values = [ "amzn-ami-vpc-nat*" ]
  }

  most_recent = true
  owners      = [ "amazon" ]
}

resource "aws_instance" "natgw" {
  count                   = var.enable_nat_instance ? 1 : 0
  ami                     = data.aws_ami.natgw.id
  instance_type           = "t3a.nano"
  ebs_optimized           = "false"
  disable_api_termination = "false"
  vpc_security_group_ids  = [ aws_security_group.natsg[0].id ]
  subnet_id               = aws_subnet.public[0].id
  key_name                = var.nat_instance_key_pair
  source_dest_check       = false

  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size           = "8"
    volume_type           = "standard"
    delete_on_termination = "true"
  }

  volume_tags = {
    Name     = "${var.vpc_name}-natgw-rootvol"
    vpc_name = var.vpc_name
  }

  tags = {
    Name     = "${var.vpc_name}-natgw"
    vpc_name = var.vpc_name
  }

  lifecycle {
    ignore_changes = [ ami ]
  }
}

################################################################################
#####     NAT GATEWAY (AWS Managed Service)

resource "aws_eip" "natgw" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc   = true

  tags = {
    Name     = "${var.vpc_name}-natgw"
    vpc_name = var.vpc_name
  }
}

resource "aws_nat_gateway" "natgw" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.natgw[0].id
  subnet_id     = element(aws_subnet.public.*.id, 0)

  tags = {
    Name     = "${var.vpc_name}-natgw"
    vpc_name = var.vpc_name
  }
}

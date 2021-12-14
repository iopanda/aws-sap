############ Route for Public Subnet ############

resource "aws_route_table" "public_rt_1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.prefix}-public-rt-${local.az_a}"
  }
}

resource "aws_route_table" "public_rt_2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.prefix}-public-rt-${local.az_c}"
  }
}

resource "aws_route" "public_rt_igw_1" {
  route_table_id         = aws_route_table.public_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sap_labs_web_igw.id
}

resource "aws_route" "public_rt_igw_2" {
  route_table_id         = aws_route_table.public_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.sap_labs_web_igw.id
}

resource "aws_route_table_association" "public_rt_1" {
  route_table_id = aws_route_table.public_rt_1.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_rt_2" {
  route_table_id = aws_route_table.public_rt_2.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

############ Route for Private Subnet ############

resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.prefix}-private-rt-${local.az_a}"
  }
}

resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.prefix}-private-rt-${local.az_c}"
  }
}

resource "aws_route" "public_rt_nat_gw_1" {
  route_table_id         = aws_route_table.private_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.sap_labs_web_nat_gw.id
}

resource "aws_route" "public_rt_nat_gw_2" {
  route_table_id         = aws_route_table.private_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.sap_labs_web_nat_gw.id
}

resource "aws_route_table_association" "private_rt_1" {
  route_table_id = aws_route_table.private_rt_1.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "private_rt_2" {
  route_table_id = aws_route_table.private_rt_2.id
  subnet_id      = aws_subnet.private_subnet_2.id
}
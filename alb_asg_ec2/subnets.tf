resource "aws_subnet" "public_subnet_1" {
  cidr_block        = local.public_subnet_1_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.az_a

  tags = {
    Name = "${local.prefix}-subnet-public-${local.az_a}"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block        = local.public_subnet_2_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.az_c

  tags = {
    Name = "${local.prefix}-subnet-public-${local.az_c}"
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block        = local.private_subnet_1_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.az_a

  tags = {
    Name = "${local.prefix}-subnet-private-${local.az_a}"
  }
}

resource "aws_subnet" "private_subnet_2" {
  cidr_block        = local.private_subnet_2_cidr
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.az_c

  tags = {
    Name = "${local.prefix}-subnet-private-${local.az_c}"
  }
}
resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.prefix}-vpc"
  }
}

resource "aws_internet_gateway" "sap_labs_web_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.prefix}-igw"
  }
}
resource "aws_nat_gateway" "sap_labs_web_nat_gw" {
  allocation_id = aws_eip.sap_labs_web_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${local.prefix}-NAT-GW"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.sap_labs_web_igw]
}
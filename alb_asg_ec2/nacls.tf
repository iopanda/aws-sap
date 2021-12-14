resource "aws_network_acl" "public_subnet" {
  vpc_id     = aws_vpc.vpc.id
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "${local.prefix}-nacls-public-subnet"
  }
}

##################### Ingress rules #####################

resource "aws_network_acl_rule" "public_subnet_ingress_100" {
  network_acl_id = aws_network_acl.public_subnet.id
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

##################### Egress rules #####################

resource "aws_network_acl_rule" "public_subnet_egress_100" {
  network_acl_id = aws_network_acl.public_subnet.id
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  rule_number    = 100
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

//resource "aws_instance" "sap_labs_web_instance_1" {
//  ami             = local.instance_ami
//  instance_type   = "t2.micro"
//  subnet_id       = aws_subnet.private_subnet_1.id
//  security_groups = [aws_security_group.sap_labs_web_instance_sg.id]
//
//  user_data = <<EOF
//  #!/bin/sh
//  yum -y install httpd php
//  chkconfig httpd on
//  systemctl start httpd.service
//  cd /var/www/html
//  wget https://s3-us-west-2.amazonaws.com/us-west-2-aws-training/awsu-spl/spl-03/scripts/examplefiles-elb.zip
//  unzip examplefiles-elb.zip
//  EOF
//
//  key_name = local.instance_key_name
//
//  tags = {
//    Name = "${local.prefix}-1"
//  }
//}
//
//resource "aws_instance" "sap_labs_web_instance_2" {
//  ami             = local.instance_ami
//  instance_type   = "t2.micro"
//  subnet_id       = aws_subnet.private_subnet_2.id
//  security_groups = [aws_security_group.sap_labs_web_instance_sg.id]
//
//  user_data = <<EOF
//  #!/bin/sh
//  yum -y install httpd php
//  chkconfig httpd on
//  systemctl start httpd.service
//  cd /var/www/html
//  wget https://s3-us-west-2.amazonaws.com/us-west-2-aws-training/awsu-spl/spl-03/scripts/examplefiles-elb.zip
//  unzip examplefiles-elb.zip
//  EOF
//
//  key_name = local.instance_key_name
//
//  tags = {
//    Name = "${local.prefix}-2"
//  }
//}

resource "aws_instance" "sap_labs_jump_box_instance" {
  ami                         = local.instance_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sap_labs_web_instance_sg.id]

  key_name = local.instance_key_name

  tags = {
    Name = "${local.prefix}-jump-box"
  }
}
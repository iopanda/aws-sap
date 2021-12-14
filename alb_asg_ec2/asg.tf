resource "aws_launch_template" "sap_labs_web_launch_template_1" {
  name_prefix   = "${local.prefix}-instance-1"
  image_id      = local.instance_ami
  instance_type = "t2.micro"

  network_interfaces {
    subnet_id       = aws_subnet.private_subnet_1.id
    security_groups = [aws_security_group.sap_labs_web_instance_sg.id]
  }

  key_name = local.instance_key_name

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_launch_template" "sap_labs_web_launch_template_2" {
  name_prefix   = "${local.prefix}-instance-2"
  image_id      = local.instance_ami
  instance_type = "t2.micro"

  network_interfaces {
    subnet_id       = aws_subnet.private_subnet_2.id
    security_groups = [aws_security_group.sap_labs_web_instance_sg.id]
  }

  key_name = local.instance_key_name

  user_data = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "sap_labs_web_asg_1" {
  availability_zones = [local.az_a]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.sap_labs_web_launch_template_1.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_group" "sap_labs_web_asg_2" {
  availability_zones = [local.az_c]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.sap_labs_web_launch_template_2.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "sap_labs_web_asg_attachment_1" {
  autoscaling_group_name = aws_autoscaling_group.sap_labs_web_asg_1.id
  alb_target_group_arn   = aws_lb_target_group.sap_labs_web_alb_target_group.arn
}

resource "aws_autoscaling_attachment" "sap_labs_web_asg_attachment_2" {
  autoscaling_group_name = aws_autoscaling_group.sap_labs_web_asg_2.id
  alb_target_group_arn   = aws_lb_target_group.sap_labs_web_alb_target_group.arn
}
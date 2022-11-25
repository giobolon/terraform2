#create alb security group
resource "aws_security_group" "create_websg" {

  name        = var.asg.asg_sg_name
  description = var.asg.asg_sg_description
  vpc_id      = var.vpc_id_pass

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.req_tags, {
    Name = var.asg.asg_sg_name
    }
  )
}

#security group web rule
resource "aws_security_group_rule" "create_web_rule_http" {
  type                     = "ingress"
  from_port                = var.web_http_rule.from_port
  to_port                  = var.web_http_rule.to_port
  protocol                 = var.web_http_rule.protocol
  source_security_group_id = var.albsg_id_pass
  security_group_id        = aws_security_group.create_websg.id
}

resource "aws_security_group_rule" "create_web_rule_ssh" {
  type                     = "ingress"
  from_port                = var.web_ssh_rule.from_port
  to_port                  = var.web_ssh_rule.to_port
  protocol                 = var.web_ssh_rule.protocol
  source_security_group_id = var.bastionsg_id_pass
  security_group_id        = aws_security_group.create_websg.id
}


#create launch configuration
resource "aws_launch_configuration" "create_launchconfig" {
  name                        = var.asg.launchconfig_name
  image_id                    = var.asg.launchconfig_ami_id
  instance_type               = var.asg.launchconfig_instance_type
  iam_instance_profile        = var.asg.launchconfig_iam_user
  key_name                    = var.asg.launchconfig_key_name
  associate_public_ip_address = false
  security_groups             = [aws_security_group.create_websg.id]
  user_data                   = file("./modules/asg_module/userdata.tpl")
}

#create auto scaling group
resource "aws_autoscaling_group" "create_asg" {
  name                      = var.asg.asg_name
  max_size                  = var.asg.asg_max_size
  min_size                  = var.asg.asg_min_size
  health_check_grace_period = var.asg.asg_health_check_grace_period
  health_check_type         = var.asg.asg_health_check_type
  desired_capacity          = var.asg.asg_desired_capacity 
  force_delete              = true
  target_group_arns         = [var.target_group_arns]
  launch_configuration      = aws_launch_configuration.create_launchconfig.name
  vpc_zone_identifier       = var.all_private_subnet

  tag {
    key                 = "Name"
    value               = var.asg.asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "GBL_CLASS_0"
    value               = "SERVICE"
    propagate_at_launch = true
  }
  tag {
    key                 = "GBL_CLASS_1"
    value               = "TEST"
    propagate_at_launch = true
  }
}
#create alb security group
resource "aws_security_group" "create_albsg" {

  name        = var.alb.alb_sg_name
  description = var.alb.alb_sg_description
  vpc_id      = var.vpc_id_pass

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.req_tags, {
    Name = var.alb.alb_sg_name
    }
  )
}

#create sg inbound rule
resource "aws_security_group_rule" "create_sg_rule" {
  count             = "${length(var.sg_rule.inbound_ip)}"
  type              = "ingress"
  from_port         = var.sg_rule.from_port
  to_port           = var.sg_rule.to_port
  protocol          = var.sg_rule.protocol_type
  cidr_blocks       = var.sg_rule.inbound_ip
  security_group_id = aws_security_group.create_albsg.id
}


#create load balancer
resource "aws_lb" "create_alb" {
  name               = var.alb.alb_name
  internal           = false
  load_balancer_type = var.alb.alb_type
  security_groups    = [aws_security_group.create_albsg.id]
  subnets            = var.all_public_subnet

  tags = merge(var.req_tags, {
    Name = var.alb.alb_name
    }
  )
}

 #create target group
resource "aws_lb_target_group" "create_tg" {
  name        = var.alb.tg_name
  target_type = var.alb.target_type
  port        = var.alb.tg_port
  protocol    = var.alb.tg_protocol
  vpc_id      = var.vpc_id_pass

  health_check {
    path                = var.alb.hc_path
    port                = var.alb.hc_port
    protocol            = var.alb.hc_protocol
    timeout             = var.alb.hc_timeout
    healthy_threshold   = var.alb.hc_healthy_threshold
    unhealthy_threshold = var.alb.hc_unhealthy_threshold
    interval            = var.alb.hc_interval
    matcher             = var.alb.hc_matcher
  }

  tags = merge(var.req_tags, {
    Name = var.alb.tg_name
    }
  )
}

#attach listener to target group
resource "aws_lb_listener" "create_listener" {
  load_balancer_arn = aws_lb.create_alb.arn
  port              = var.alb.listener_port
  protocol          = var.alb.listener_protocol

  default_action {
    type             = var.alb.listener_type
    target_group_arn = aws_lb_target_group.create_tg.arn
  }
}
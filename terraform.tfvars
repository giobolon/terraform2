#Input Region ====================================================================
region = "ap-northeast-1"

#Enter VPC Details
vpc = {
  #CIDR and internet gateway
  cidr_block = "10.100.0.0/16"
  vpc_name   = "skillup-j.bolon-vpc"
  igw_name   = "skillup-j.bolon-igw"

  #VPC subnets
  subnet_pub_name = ["skillup-j.bolon-pub-1", "skillup-j.bolon-pub-2"]
  pub_av_zone     = ["ap-northeast-1a", "ap-northeast-1c"]
  pub_cidr        = ["10.100.1.0/24", "10.100.2.0/24"]

  subnet_priv_name = ["skillup-j.bolon-priv-1", "skillup-j.bolon-priv-2"]
  priv_av_zone     = ["ap-northeast-1a", "ap-northeast-1c"]
  priv_cidr        = ["10.100.3.0/24", "10.100.4.0/24"]

  subnet_db_name = ["skillup-j.bolon-db-1", "skillup-j.bolon-db-2"]
  db_av_zone     = ["ap-northeast-1a", "ap-northeast-1c"]
  db_cidr        = ["10.100.5.0/24", "10.100.6.0/24"]

  #NAT gateway
  nat_name = "skillup-j.bolon-nat"

  #elastic_ip is just a reference 
  elastic_ip_allocation_id = "eipalloc-0a6833a9c92d3cefc"

  #Route table details and endpoint
  pubrt_name       = "skillup-j.bolon-pubrt"
  privrt_name      = "skillup-j.bolon-privrt"
  s3_endpoint_name = "skillup-j.bolon-s3endpoint"
}

#Enter Bastion Details=======================================================================
bastion = {
  #Security group details
  bastion_sg_name        = "skillup-j.bolon-bastion-sg"
  bastion_sg_description = "SG for j.bolon bastion"

  #Input Bastion details and specs
  bastion_name      = "skillup-j.bolon-bastion"
  ami_id            = "ami-09b18720cb71042df"
  ec2_instance_type = "t2.micro"
  ec2_az            = "ap-northeast-1c"
  key_name          = "skillup-j.bolon-pem"
  iam_user          = "skillup-j.bolon-readonly"
}

#Bastion SG rule
bastion_sg_rule_tcp_6522 = {
  from_port     = "6522"
  to_port       = "6522"
  protocol_type = "tcp"
  inbound_ip    = ["112.201.105.205/32"]
}


#Enter Load Balancer Details======================================================================
alb = {
  #Security group details
  alb_sg_name        = "skillup-j.bolon-alb-sg"
  alb_sg_description = "SG for j.bolon alb"

  #Applciation Load Balancer
  alb_name = "skillup-j-bolon-alb"
  alb_type = "application"

  #Target Group
  tg_name     = "skillup-jbolon-tg"
  target_type = "instance"
  tg_port     = "80"
  tg_protocol = "HTTP"
  #Health Check
  hc_path                = "/"
  hc_port                = "80"
  hc_protocol            = "HTTP"
  hc_timeout             = "5"
  hc_healthy_threshold   = "3"
  hc_unhealthy_threshold = "3"
  hc_interval            = "200"
  hc_matcher             = "200-499"
  #Listener
  listener_port     = "80"
  listener_protocol = "HTTP"
  listener_type     = "forward"
}
#Input ALB SG rule
alb_sg_rule_tcp_80 = {
  from_port     = "80"
  to_port       = "80"
  protocol_type = "tcp"
  inbound_ip    = ["112.201.105.205/32"]
}

#Active Scaling Group===============================================================
asg = {
  #Security group details
  asg_sg_name        = "skillup-j.bolon-web-sg"
  asg_sg_description = "SG for j.bolon web"

  #Launch configuration details
  launchconfig_name          = "skillup-j.bolon-lc"
  launchconfig_ami_id        = "ami-09b18720cb71042df"
  launchconfig_instance_type = "t2.micro"
  launchconfig_iam_user      = "skillup-j.bolon-readonly"
  launchconfig_key_name      = "skillup-j.bolon-pem"

  #Auto Scaling Group details
  asg_name                      = "skillup-j.bolon-web"
  asg_max_size                  = "2"
  asg_min_size                  = "2"
  asg_health_check_grace_period = "200"
  asg_health_check_type         = "ELB"
  asg_desired_capacity          = "2"

}

#Input WEB SG rule
web_sg_rule_http_80 = {
  from_port = "80"
  to_port   = "80"
  protocol  = "tcp"
}

web_sg_rule_ssh_6522 = {
  from_port = "6522"
  to_port   = "6522"
  protocol  = "tcp"
}
variable "alb" {
  type = object({
  alb_sg_name = string
  alb_sg_description = string
  alb_name = string
  alb_type = string
  tg_name = string
  target_type = string
  tg_port = string
  tg_protocol = string
  hc_path                = string
  hc_port                = string
  hc_protocol            = string
  hc_timeout             = string
  hc_healthy_threshold   = string
  hc_unhealthy_threshold = string
  hc_interval            = string
  hc_matcher             = string
  listener_port = string
  listener_protocol = string
  listener_type = string
   })
}
variable "sg_rule" {
  type = object({
  from_port = string
  to_port = string
  protocol_type = string
  inbound_ip = list(string)
   })
}

variable "vpc_id_pass" {
 type = string
}

variable "all_public_subnet" {
 type= list(string)
}


variable "req_tags" {
  description = "Skillup required tags"
  type        = map(string)
  default = {
    "GBL_CLASS_0" = "SERVICE"
    "GBL_CLASS_1" = "TEST"
  }
}
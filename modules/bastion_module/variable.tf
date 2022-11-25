variable "bastion" {
  type = object({
  bastion_sg_name = string
  bastion_sg_description = string
  bastion_name = string
  ami_id = string
  ec2_instance_type = string
  ec2_az =string
  key_name = string
  iam_user = string
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

variable "subnet_id_pass" {
type = string
}

variable "vpc_id_pass" {
 type = string
}

variable "req_tags" {
  description = "Skillup required tags"
  type        = map(string)
  default = {
    "GBL_CLASS_0" = "SERVICE"
    "GBL_CLASS_1" = "TEST"
  }
}
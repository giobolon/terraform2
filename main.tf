#provider block
provider "aws" {
  region = var.region
}

#VPC
module "vpc_module" {
  source = "./modules/vpc_module/"
  vpc    = var.vpc
}

#Bastion
module "bastion_module" {
  source         = "./modules/bastion_module/"
  bastion        = var.bastion
  sg_rule        = var.bastion_sg_rule_tcp_6522
  vpc_id_pass    = module.vpc_module.vpc_id
  subnet_id_pass = module.vpc_module.subnet_id_out
}

#ALB
module "alb_module" {
  source            = "./modules/alb_module/"
  alb               = var.alb
  sg_rule           = var.alb_sg_rule_tcp_80
  vpc_id_pass       = module.vpc_module.vpc_id
  all_public_subnet = module.vpc_module.all_public_subnet
}

#ASG
module "asg_module" {
  source             = "./modules/asg_module/"
  asg                = var.asg
  vpc_id_pass        = module.vpc_module.vpc_id
  albsg_id_pass      = module.alb_module.alb_sg_id
  bastionsg_id_pass  = module.bastion_module.bastion_sg_id
  all_private_subnet = module.vpc_module.all_private_subnet
  target_group_arns  = module.alb_module.tg_arns
  web_http_rule      = var.web_sg_rule_http_80
  web_ssh_rule       = var.web_sg_rule_ssh_6522
}


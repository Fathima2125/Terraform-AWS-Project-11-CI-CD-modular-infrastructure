module "network" {
  source         = "./modules/network"
  vpc_cidr       = var.vpc_cidr
  subnet_cidr_1  = var.subnet_cidr_1
  subnet_cidr_2  = var.subnet_cidr_2
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "compute" {
  source        = "./modules/compute"
  instance_type = var.instance_type
  key_name      = var.key_name
  sg_id         = module.security.sg_id
}

module "alb" {
  source      = "./modules/alb"
  subnet_ids  = module.network.subnet_ids
  vpc_id      = module.network.vpc_id
  alb_sg      = module.security.sg_id
}

module "asg" {
  source               = "./modules/asg"
  subnet_ids           = module.network.subnet_ids
  launch_template_id   = module.compute.launch_template_id
  target_group_arn     = module.alb.target_group_arn
}

module "monitoring" {
  source = "./modules/monitoring"

  asg_name       = module.asg.asg_name
  alb_arn_suffix = module.alb.alb_arn_suffix
  alert_email    = var.alert_email
}
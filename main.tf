module "network" {
  source = "./modules/network"
  region = var.aws_region
}
module "compute" {
  source = "./modules/compute"
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  instance_type = var.instance_type
  alb_security_group_id = module.alb.security_group_id
}
module "alb" {
  source = "./modules/alb"
  vpc_id = module.network.vpc_id
  subnet_ids = module.network.public_subnet_ids
  instance_ids = module.compute.instance_ids
}
module "monitoring" {
  source = "./modules/monitoring"
  count = var.enable_alarms ? 1 : 0
  instance_ids = module.compute.instance_ids
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  load_balancer_arn_suffix = module.alb.load_balancer_arn_suffix
}

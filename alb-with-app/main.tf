module "alb" {
  source          = "./alb"
  alb_name        = var.alb_name
  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups
  target_groups   = var.target_groups
  instances       = var.instances
}


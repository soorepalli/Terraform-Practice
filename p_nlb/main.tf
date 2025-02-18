module "nlb" {
  source                     = "./nlb"
  nlb_name                   = var.nlb_name
  vpc_id                     = var.vpc_id
  subnets                    = var.subnets
  internal                   = var.internal
  target_groups              = var.target_groups
  enable_deletion_protection = var.enable_deletion_protection
  security_group_id          = var.security_group_id
}
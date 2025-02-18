### MODULE (./modules/nlb/main.tf) ###

resource "aws_lb" "nlb" {
  name               = var.nlb_name
  #internal           = false
  internal           = var.internal
  load_balancer_type = "network"
  subnets            = var.subnets

  #enable_deletion_protection = false
  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.nlb_name
  }
}

resource "aws_lb_target_group" "tg" {
  count = length(var.target_groups)

  name_prefix = var.target_groups[count.index].name_prefix
  port        = var.target_groups[count.index].port
  protocol    = var.target_groups[count.index].protocol
  vpc_id      = var.vpc_id
  target_type = var.target_groups[count.index].target_type
}

resource "aws_lb_listener" "nlb_listener" {
  count             = length(var.target_groups)
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.target_groups[count.index].port
  protocol          = var.target_groups[count.index].protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[count.index].arn
  }
}

resource "aws_security_group_rule" "nlb_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = var.security_group_id
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "Allow all inbound traffic"
}


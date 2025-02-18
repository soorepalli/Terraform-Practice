### MODULE (./modules/alb/main.tf) ###

resource "aws_lb" "main" {
  # count              = var.existing_alb_arn == "" ? 1 : 0
  name               = var.alb_name
  # internal           = false
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  # enable_deletion_protection = false
  enable_deletion_protection = var.enable_deletion_protection

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "tg" {
  count = length(var.target_groups)

  name_prefix = var.target_groups[count.index].name_prefix
  port        = var.target_groups[count.index].port
  protocol    = var.target_groups[count.index].protocol
  vpc_id      = var.vpc_id
  target_type = var.target_groups[count.index].target_type

  health_check {
    path                = var.target_groups[count.index].health_check.path
    interval            = var.target_groups[count.index].health_check.interval
    timeout             = var.target_groups[count.index].health_check.timeout
    healthy_threshold   = var.target_groups[count.index].health_check.healthy_threshold
    unhealthy_threshold = var.target_groups[count.index].health_check.unhealthy_threshold
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  count = length(var.instances)

  target_group_arn = aws_lb_target_group.tg[0].arn
  target_id        = var.instances[count.index]
}

resource "aws_security_group_rule" "alb_inbound" {
  for_each = toset(var.security_groups)

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = each.value
}

resource "aws_security_group_rule" "alb_inbound_https" {
  for_each = toset(var.security_groups)

  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = each.value
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}

/*
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}

resource "aws_lb_listener_rule" "example" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  conditions {
    host_header {
      values = ["example.com"]
    }
  }

  actions {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}
*/

resource "aws_lb_listener_rule" "http_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg[0].arn
  }
}
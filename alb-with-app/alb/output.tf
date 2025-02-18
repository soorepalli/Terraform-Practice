output "alb_arn" {
  value = aws_lb.main.arn
}


output "target_group_arns" {
  value = aws_lb_target_group.tg[*].arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}
output "alb_arn" {
  value = aws_lb.main.arn
}

output "alb_arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics"
  value       = element(concat(aws_lb.main.*.arn_suffix, [""]), 0)
}

output "target_group_arns" {
  value = aws_lb_target_group.tg[*].arn
}
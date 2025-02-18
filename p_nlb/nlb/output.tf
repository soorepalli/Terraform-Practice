output "nlb_arn" {
  value = aws_lb.nlb.arn
}

output "nlb_arn_suffix" {
  description = "The ARN suffix for use with CloudWatch Metrics"
  value       = element(concat(aws_lb.nlb.*.arn_suffix, [""]), 0)
}

output "listener_arn" {
  description = "The ARN of the listener"
  value       = element(concat(aws_lb_listener.nlb_listener.*.arn, [""]), 0)
}
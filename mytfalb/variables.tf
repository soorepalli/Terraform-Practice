### VARIABLES ###

variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ALB will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "Security groups for ALB"
  type        = list(string)
}

variable "target_groups" {
  description = "List of target groups with dynamic values"
  type = list(object({
    name_prefix = string
    port        = number
    protocol    = string
    target_type = string
    health_check = object({
      path                = string
      interval            = number
      timeout             = number
      healthy_threshold   = number
      unhealthy_threshold = number
    })
  }))
  validation {
    condition     = alltrue([for tg in var.target_groups : length(tg.name_prefix) <= 6])
    error_message = "Each name_prefix must be 6 characters or fewer."
  }
}

variable "instances" {
  description = "List of instance IDs to register with the target groups"
  type        = list(string)
}


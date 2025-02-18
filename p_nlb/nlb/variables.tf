### VARIABLES ###

variable "nlb_name" {
  description = "Name of the Network Load Balancer"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where NLB will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for NLB"
  type        = list(string)
}

variable "internal" {
  description = "If true, the LB will be internal"
  type        = bool
  default     = true
}


variable "target_groups" {
  description = "List of target groups with dynamic values"
  type = list(object({
    name_prefix = string
    port        = number
    protocol    = string
    target_type = string
  }))
  validation {
    condition     = alltrue([for tg in var.target_groups : length(tg.name_prefix) <= 6])
    error_message = "Each name_prefix must be 6 characters or fewer."
  }
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
  type        = bool
  default     = false
}

variable "port" {
  description = "The port on which the load balancer is listening"
  type        = string
  default     = "80"
}

variable "protocol" {
  description = "The protocol for connections from clients to the load balancer"
  type        = string
  default     = "TCP"
}

variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "The ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS"
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "Security Group ID for NLB"
  type        = string
}
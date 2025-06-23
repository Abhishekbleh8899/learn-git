variable "vpc-config" {
  description = "to get the cidr and name of vpc from user "
  type = object({
    cidr_block = string
    name       = string
  })
  validation {
    condition     = can(cidrnetmask(var.vpc-config.cidr_block))
    error_message = "Please provide a valid CIDR block for the VPC."
  }
}

variable "subnet-config" {
  description = "to get the cidr and az of subnet from user "
  type = map(object({
    cidr_block = string
    az         = string
    public     = optional(bool, false)
  }))
  validation {
    condition     = alltrue([for config in var.subnet-config : can(cidrnetmask(config.cidr_block))])
    error_message = "Please provide a valid CIDR block for the VPC."
  }
}

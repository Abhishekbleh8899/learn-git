variable "name" {
  description = "Name of the security group"
  type        = string
  
}
variable "tag_name" {
    description = "Name tag for the security group"
    type        = string
  
}
variable "vpc_id" {
  type        = string
  description = "vpc id"
  
}
variable "ingress_rules" {
    description = "List of ingress rules"
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default = []
}

variable "egress_rules" {
    description = "List of egress rules"
    type = list(object({
        from_port   = number
        to_port     = number
        protocol    = string
        cidr_blocks = list(string)
    }))
    default = []
  
}

# #########################


# variable "sub_sg" {
#   type = object({
#     name        = string
#     description = string
#     req_ports   = list(number)
#     req_protocol = list(string)
#     req_cidr    = list(string)
#   })
# }

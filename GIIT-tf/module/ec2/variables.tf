variable "ami" {
  type        = string
  description = "ubuntu ami"
}
variable "instance_type" {
  type = string
}
variable "key_name" {
  type        = string
  description = "name of key pair"
}
variable "vpc_security_group_ids" {
  type        = list(string)
  description = "security group ids"
  
}
variable "iam_instance_profile" {
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the instance in"
  type        = string
}

variable "associate_public_ip" {
  type        = bool
  default     = true
  description = "if public ip too be associated with ec2"
}
variable "vpc_id" {
  type        = string
  description = "vpc id"
  
}

variable "name" {
  type        = string
  description = "name of ec2 instance"
}
variable "user_data" {
  type        = string
  description = "user data"
}



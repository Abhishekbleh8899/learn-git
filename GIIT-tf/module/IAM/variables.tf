variable "iam_role_name" {
  description = "Name of the IAM role"
  type        = string
  
}

variable "policy_arn" {
  description = "ARN of the IAM policy to attach"
  type        = string
  
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
  
}

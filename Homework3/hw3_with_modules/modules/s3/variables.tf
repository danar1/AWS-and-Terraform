
##################################################################################
# VARIABLES
##################################################################################

variable "aws_region" {
  description = "AWS region"
}

variable "bucket" {
  type    = string
}

variable "acl" {
  type    = string
}

variable "role_name" {
  type    = string
}

variable "s3_policy_name" {
  type    = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "s3_tags" {
  description = "Additional tags for the S3 bucket"
  type        = map(string)
}

variable "ec2_iam_role_tags" {
  description = "A map of tags to add to all ec2 iam role"
  type        = map(string)
}

##################################################################################
# VARIABLES
##################################################################################

# vpc modules var
variable "aws_region" {
  description = "AWS region"
  # default     = "us-east-1"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "instance_type" {
  type    = string
}

variable "public_subnet_count" {
  type    = number
  
}

variable "private_subnet_count" {
  type    = number
  
}

variable "public_instance_count" {
  type    = number
  
}

variable "private_instance_count" {
  type    = number
  
}

variable "public_subnets" {
  type    = list(string)
  
}

variable "private_subnets" {
  type    = list(string)
  
}

variable "bucket" {
  type    = string
}

variable "health_check" {
  type    = map(any)
}

variable "stickiness_cookie_duration" {
  description = "stickiness cookie duration in seconds"
  type        = number
}

variable "vpc_id" {
  type    = string
}

variable "instance_profile" {
  type    = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "sg_web_tags" {
  description = "Additional tags for web security group"
  type        = map(string)
}

variable "sg_db_tags" {
  description = "Additional tags for db security group"
  type        = map(string)
}

variable "sg_alb_tags" {
  description = "Additional tags for ALB security group"
  type        = map(string)
}

variable "web_tags" {
  description = "Additional tags for web instances"
  type        = map(string)
}

variable "db_tags" {
  description = "Additional tags for db instances"
  type        = map(string)
}

variable "alb_tags" {
  description = "Additional tags for ALB"
  type        = map(string)
}

variable "tg_tags" {
  description = "Additional tags for target group"
  type        = map(string)
}
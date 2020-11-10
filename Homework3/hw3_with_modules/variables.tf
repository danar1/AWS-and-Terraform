##################################################################################
# VARIABLES 
##################################################################################

# vpc modules var
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = true
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnet"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnet"
  type        = map(string)
  default     = {}
}

variable "gw_tags" {
  description = "Additional tags for the GW"
  type        = map(string)
  default     = {}
}

variable "eip_tags" {
  description = "Additional tags for the S3 EIP"
  type        = map(string)
  default     = {}
}

variable "nat_tags" {
  description = "Additional tags for the NAT"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route table"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route table"
  type        = map(string)
  default     = {}
}

# ec2 module tags
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "sg_web_tags" {
  description = "Additional tags for web security group"
  type        = map(string)
  default     = {}
}

variable "sg_db_tags" {
  description = "Additional tags for db security group"
  type        = map(string)
  default     = {}
}

variable "sg_alb_tags" {
  description = "Additional tags for ALB security group"
  type        = map(string)
  default     = {}
}

variable "web_tags" {
  description = "Additional tags for web instances"
  type        = map(string)
  default     = {}
}

variable "db_tags" {
  description = "Additional tags for db instances"
  type        = map(string)
  default     = {}
}

variable "alb_tags" {
  description = "Additional tags for ALB"
  type        = map(string)
  default     = {}
}

variable "tg_tags" {
  description = "Additional tags for target group"
  type        = map(string)
  default     = {}
}

variable "health_check" {
  type    = map(any)
  default = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 80
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 5
        unhealthy_threshold = 2
  }
}

variable "stickiness_cookie_duration" {
  description = "stickiness cookie duration in seconds"
  type        = number
  default     = 60
}

# s3 module vars
variable "bucket" {
  type    = string
  default = "ops-dana-bucket"
}

variable "acl" {
  type    = string
  default = "private"
}

variable "role_name" {
  type    = string
  default = "ops-ec2-iam-role"
}

variable "s3_policy_name" {
  type    = string
  default = "ops-s3-policy"
}

variable "s3_tags" {
  description = "Additional tags for the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "ec2_iam_role_tags" {
  description = "A map of tags to add to all ec2 iam role"
  type        = map(string)
  default     = {}
}

##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    Purpose   = "learning"
    Owner     = "dana"
  }

}
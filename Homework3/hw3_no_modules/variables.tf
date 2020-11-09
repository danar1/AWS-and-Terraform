
##################################################################################
# VARIABLES
##################################################################################
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
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

variable "bucket" {
  type    = string
  default = "ops-dana-bucket"
}

variable "role_name" {
  type    = string
  default = "ops-ec2-iam-role"
}

variable "s3_policy_name" {
  type    = string
  default = "ops-s3-policy"
}


##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    Purpose   = "learning"
    Owner     = "dana"
  }

  public_instance_count  = 2
  private_instance_count = 2
  public_subnet_count    = length(var.azs)
  private_subnet_count   = length(var.azs)

#   user_data = <<EOF
# #!/bin/bash
# sudo apt-get update
# sudo apt-get install nginx -y
# echo '<html><head><title>OpsSchool Rules</title></head><body style=\"background-color: purple\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">OpsSchool Rules</span></span></p></body></html>' | sudo tee /var/www/html/index.nginx-debian.html
# EOF
# }

}

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

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.100.0/24", "10.0.200.0/24"]
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

##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    Purpose   = "learning"
    Owner     = "dana"
  }

  public_instance_count  = length(var.public_subnets)
  private_instance_count = length(var.private_subnets)

  user_data = <<EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
echo '<html><head><title>OpsSchool Rules</title></head><body style=\"background-color: purple\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">OpsSchool Rules</span></span></p></body></html>' | sudo tee /var/www/html/index.nginx-debian.html
EOF
}


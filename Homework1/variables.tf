##################################################################################
# VARIABLES
##################################################################################

# Using aws default credentials file instead of aws_access_key and aws_secret_key
# variable "aws_access_key" {}
# variable "aws_secret_key" {}
variable "private_key_path" {}
variable "key_name" {}
variable "region" {
  default = "us-east-1"
}
variable "instance_count" {
  default = 2
}

##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    Purpose = "learning"
    Owner = "dana"
  }
}


# ##################################################################################
# # VARIABLES
# ##################################################################################

# variable "aws_region" {
#   description = "AWS region"
# }

# variable "cidr_block" {
#   description = "The CIDR block for the VPC"
#   type        = string
# }

# variable "azs" {
#   type    = list(string)
# }

# variable "map_public_ip_on_launch" {
#   type    = bool
# }

# variable "public_subnet_count" {
#   description = "Amount of public subnets"
#   type        = int
# }


# variable "private_subnet_count" {
#   description = "Amount of private subnets"
#   type        = int
# }


# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {}
# }

# variable "vpc_tags" {
#   description = "Additional tags for the VPC"
#   type        = map(string)
#   default     = {}
# }

# variable "public_subnet_tags" {
#   description = "Additional tags for the public subnet"
#   type        = map(string)
#   default     = {}
# }

# variable "private_subnet_tags" {
#   description = "Additional tags for the private subnet"
#   type        = map(string)
#   default     = {}
# }

# variable "gw_tags" {
#   description = "Additional tags for the GW"
#   type        = map(string)
#   default     = {}
# }

# variable "nat_tags" {
#   description = "Additional tags for the NAT"
#   type        = map(string)
#   default     = {}
# }

# # variable "eip_tags" {
# #   description = "Additional tags for the EIP"
# #   type        = map(string)
# #   default     = {}
# # }

# variable "public_route_table_tags" {
#   description = "Additional tags for the public route table"
#   type        = map(string)
#   default     = {}
# }

# variable "private_route_table_tags" {
#   description = "Additional tags for the private route table"
#   type        = map(string)
#   default     = {}
# }




# ##################################################################################
# # LOCALS
# ##################################################################################

# locals {
#   common_tags = {
#     Purpose   = "learning"
#     Owner     = "dana"
#   }

#   public_instance_count  = 2
#   private_instance_count = 2
#   public_subnet_count    = length(var.azs)
#   private_subnet_count   = length(var.azs)

# }


###



##################################################################################
# VARIABLES
##################################################################################

variable "aws_region" {
  description = "AWS region"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "azs" {
  type    = list(string)
}

variable "map_public_ip_on_launch" {
  type    = bool
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  type        = map(string)
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnet"
  type        = map(string)
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnet"
  type        = map(string)
}

variable "gw_tags" {
  description = "Additional tags for the GW"
  type        = map(string)
}

variable "eip_tags" {
  description = "Additional tags for the EIP"
  type        = map(string)
}

variable "nat_tags" {
  description = "Additional tags for the NAT"
  type        = map(string)
}

variable "public_route_table_tags" {
  description = "Additional tags for the public route table"
  type        = map(string)
}

variable "private_route_table_tags" {
  description = "Additional tags for the private route table"
  type        = map(string)
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

}
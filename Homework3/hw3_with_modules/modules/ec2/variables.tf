
# ##################################################################################
# # VARIABLES
# ##################################################################################

# variable "public_subnet_count" {
#   type    = int
  
# }

# variable "private_subnet_count" {
#   type    = int
  
# }

# variable "public_instance_count" {
#   type    = int
  
# }

# variable "private_instance_count" {
#   type    = int
  
# }

# variable "instance_type" {
#   type    = string
#   default = "t2.micro"
# }

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
#   default     = {}
# }

# variable "aws_eip_tags" {
#   description = "Additional tags for the S3 EIP"
#   type        = map(string)
#   default     = {}
# }

# variable "nat_gw_tags" {
#   description = "Additional tags for the nat gw"
#   type        = map(string)
#   default     = {}
# }

# variable "rt_public_tags" {
#   description = "Additional tags for publict route table"
#   type        = map(string)
#   default     = {}
# }

# variable "rt_private_tags" {
#   description = "Additional tags for private route table"
#   type        = map(string)
#   default     = {}
# }

# variable "sg_web_tags" {
#   description = "Additional tags for web security group"
#   type        = map(string)
#   default     = {}
# }

# variable "sg_db_tags" {
#   description = "Additional tags for db security group"
#   type        = map(string)
#   default     = {}
# }

# variable "sg_alb_tags" {
#   description = "Additional tags for ALB security group"
#   type        = map(string)
#   default     = {}
# }

# variable "web_tags" {
#   description = "Additional tags for web instances"
#   type        = map(string)
#   default     = {}
# }

# variable "db_tags" {
#   description = "Additional tags for db instances"
#   type        = map(string)
#   default     = {}
# }

# variable "alb_tags" {
#   description = "Additional tags for ALB"
#   type        = map(string)
#   default     = {}
# }

# variable "tg_tags" {
#   description = "Additional tags for target group"
#   type        = map(string)
#   default     = {}
# }

# variable "health_check" {
#   type    = map(any)
#   default = {
#         enabled             = true
#         interval            = 30
#         path                = "/"
#         port                = 80
#         protocol            = "HTTP"
#         timeout             = 5
#         healthy_threshold   = 5
#         unhealthy_threshold = 2
#   }
# }

# variable "stickiness_cookie_duration" {
#   description = "stickiness cookie duration in seconds"
#   type        = int
#   default     = 60
# }



# ##################################################################################
# # VARIABLES
# ##################################################################################

# variable "public_subnet_count" {
#   type    = int
  
# }

# variable "private_subnet_count" {
#   type    = int
  
# }

# variable "public_instance_count" {
#   type    = int
  
# }

# variable "private_instance_count" {
#   type    = int
  
# }

# variable "instance_type" {
#   type    = string
# }

# variable "tags" {
#   description = "A map of tags to add to all resources"
#   type        = map(string)
# }

# # variable "aws_eip_tags" {
# #   description = "Additional tags for the S3 EIP"
# #   type        = map(string)
# # }

# # variable "nat_gw_tags" {
# #   description = "Additional tags for the nat gw"
# #   type        = map(string)
# # }

# # variable "rt_public_tags" {
# #   description = "Additional tags for publict route table"
# #   type        = map(string)
# # }

# # variable "rt_private_tags" {
# #   description = "Additional tags for private route table"
# #   type        = map(string)
# # }

# variable "sg_web_tags" {
#   description = "Additional tags for web security group"
#   type        = map(string)
# }

# variable "sg_db_tags" {
#   description = "Additional tags for db security group"
#   type        = map(string)
# }

# variable "sg_alb_tags" {
#   description = "Additional tags for ALB security group"
#   type        = map(string)
# }

# variable "web_tags" {
#   description = "Additional tags for web instances"
#   type        = map(string)
# }

# variable "db_tags" {
#   description = "Additional tags for db instances"
#   type        = map(string)
# }

# variable "alb_tags" {
#   description = "Additional tags for ALB"
#   type        = map(string)
# }

# variable "tg_tags" {
#   description = "Additional tags for target group"
#   type        = map(string)
# }

# variable "health_check" {
#   type    = map(any)
# }

# variable "stickiness_cookie_duration" {
#   description = "stickiness cookie duration in seconds"
#   type        = int
# }


##################################################################################
# VARIABLES
##################################################################################

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

variable "health_check" {
  type    = map(any)
}

variable "stickiness_cookie_duration" {
  description = "stickiness cookie duration in seconds"
  type        = number
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
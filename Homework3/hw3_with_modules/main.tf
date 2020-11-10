
# ##################################################################################
# # VPC
# ##################################################################################

# module "vpc" {
#   source                   = "./modules/vpc" 
#   aws_region               = var.aws_region
#   azs                      = var.azs
#   cidr_block               = var.cidr_block
#   map_public_ip_on_launch  = var.map_public_ip_on_launch
#   # public_subnet_count      = local.public_subnet_count
#   # private_subnet_count     = loca.private_subnet_count
#   tags                     = local.common_tags
#   vpc_tags                 = var.vpc_tags
#   public_subnet_tags       = var.public_subnet_tags
#   private_subnet_tags      = var.private_subnet_tags
#   gw_tags                  = var.gw_tags
#   nat_tags                 = var.nat_tags
#   public_route_table_tags  = var.public_route_table_tags
#   private_route_table_tags = var.private_route_table_tags
# }

# ##################################################################################
# # EC2 
# ##################################################################################
# # web/db instances, alb, security groups (web/db/alb)
# module "ec2" {
#   source                     = "./modules/ec2"
#   public_subnet_count        = module.vpc.public_subnet_count
#   private_subnet_count       = module.vpc.private_subnet_count
#   public_instance_count      = module.vpc.public_instance_count
#   private_instance_count     = module.vpc.private_instance_count
#   instance_type              = var.instance_type
#   health_check               = var.health_check
#   stickiness_cookie_duration = var.stickiness_cookie_duration
#   tags                       = local.common_tags
#   aws_eip_tags               = var.aws_eip_tags
#   nat_gw_tags                = var.nat_gw_tags
#   rt_public_tags             = var.rt_public_tags
#   rt_private_tags            = var.rt_private_tags
#   sg_web_tags                = var.sg_web_tags
#   sg_db_tags                 = var.sg_db_tags
#   sg_alb_tags                = var.sg_alb_tags
#   web_tags                   = var.web_tags
#   db_tags                    = var.db_tags
#   alb_tags                   = var.alb_tags
#   tg_tags                    = var.tg_tags
# }

# ##################################################################################
# # S3
# ##################################################################################
# # bucket, role, instance profile
# module "s3" {
#   source            = "./modules/s3"
#   bucket            = var.bucket
#   acl               = var.acl
#   role_name         = var.role_name
#   s3_policy_name    = var.s3_policy_name
#   s3_tags           = var.s3_tags
#   ec2_iam_role_tags = var.ec2_iam_role_tags
# }



##################################################################################
# VPC
##################################################################################

module "vpc" {
  source                   = "./modules/vpc" 
  aws_region               = var.aws_region
  cidr_block               = var.cidr_block
  azs                      = var.azs
  map_public_ip_on_launch  = var.map_public_ip_on_launch
  tags                     = local.common_tags
  vpc_tags                 = var.vpc_tags
  public_subnet_tags       = var.public_subnet_tags
  private_subnet_tags      = var.private_subnet_tags
  gw_tags                  = var.gw_tags
  eip_tags                 = var.eip_tags
  nat_tags                 = var.nat_tags
  public_route_table_tags  = var.public_route_table_tags
  private_route_table_tags = var.private_route_table_tags

}

##################################################################################
# EC2 
##################################################################################
# web/db instances, alb, security groups (web/db/alb)
module "ec2" {
  source                     = "./modules/ec2"
  instance_type              = var.instance_type
  public_subnet_count        = module.vpc.public_subnet_count
  private_subnet_count       = module.vpc.private_subnet_count
  public_instance_count      = module.vpc.public_instance_count
  private_instance_count     = module.vpc.private_instance_count
  health_check               = var.health_check
  stickiness_cookie_duration = var.stickiness_cookie_duration
  tags                       = local.common_tags
  sg_web_tags                = var.sg_web_tags
  sg_db_tags                 = var.sg_db_tags
  sg_alb_tags                = var.sg_alb_tags
  web_tags                   = var.web_tags
  db_tags                    = var.db_tags
  alb_tags                   = var.alb_tags
  tg_tags                    = var.tg_tags
}

##################################################################################
# S3
##################################################################################
# bucket, role, instance profile
module "s3" {
  source            = "./modules/s3"
  bucket            = var.bucket
  acl               = var.acl
  role_name         = var.role_name
  s3_policy_name    = var.s3_policy_name
  tags              = local.common_tags
  s3_tags           = var.s3_tags
  ec2_iam_role_tags = var.ec2_iam_role_tags
}
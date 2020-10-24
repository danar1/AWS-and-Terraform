##################################################################################
# TERRAFORM
##################################################################################
terraform {

  required_version = "0.13.4"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.11.0"
    }
  }
}

##################################################################################
# PROVIDERS
##################################################################################
provider "aws" {
  region = var.aws_region
}

##################################################################################
# DATA
##################################################################################
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

##################################################################################
# RESOURCES [modules]
##################################################################################

# vpc, subnets [public/private], igw, NAT, route table [public: all -> igw], [private: all -> NAT]
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.62.0"

  name = "vpc-ops"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  create_igw      = true

  # Single NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  # Tags
  tags = local.common_tags

}

# Security Groups [web, db, alb]
module "sg-web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name                = "sg_web"
  description         = "Security group for public web servers with HTTP/80 and SSH/22 ports open [inbound] and all open [outbound]"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "sg-db" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name                = "sg_db"
  description         = "Security group for private db servers with SSH/22 port open within VPC [inbound], and all open [outbound]"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["ssh-tcp"]
  egress_rules        = ["all-all"]
}

module "sg-alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name                = "sg_alb"
  description         = "Security group for application load balancer with HTTP/80 open [inbound] and all open [outbound]"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_rules        = ["all-all"]
}

# Instances [web, db]
module "web" {
  source                  = "terraform-aws-modules/ec2-instance/aws"
  version                 = "~> 2.0"

  name                    = "web-cluster"
  instance_count          = 2
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.key_pair.key_name
  vpc_security_group_ids  = [module.sg-web.this_security_group_id]
  subnet_ids              = module.vpc.public_subnets
  # user_data               = local.user_data
  user_data_base64        = base64encode(local.user_data)

  # Tags
  tags = local.common_tags
}

module "db" {
  source                  = "terraform-aws-modules/ec2-instance/aws"
  version                 = "~> 2.0"

  name                    = "db-cluster"
  instance_count          = 2
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.key_pair.key_name
  vpc_security_group_ids  = [module.sg-db.this_security_group_id]
  subnet_ids              = module.vpc.private_subnets

  # Tags
  tags = local.common_tags
}

# Application Load Balancer
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.9.0"

  name = "alb-ops"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.sg-alb.this_security_group_id]

  target_groups = [
    {
      name_prefix      = "alb-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check     = var.health_check
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  # Tags
  tags = local.common_tags
}

# Attach targets to target group 
resource "aws_lb_target_group_attachment" "targets_to_target_group_attach" {
  count            = local.subnet_count
  target_group_arn = module.alb.target_group_arns[0]
  target_id        = module.web.id[count.index]
  port             = 80
}
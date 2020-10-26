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
# RESOURCES
##################################################################################

# vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags       = local.common_tags
}

# public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags                    = local.common_tags
}

# private subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = element(var.azs, count.index)

  tags                    = local.common_tags
}

# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags   = local.common_tags
}

# EIP 
resource "aws_eip" "nat" {
  vpc    = true
}

# Nat GW
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.*.id[0]

  tags          = local.common_tags
  depends_on    = [aws_internet_gateway.gw]
}

# Rout table for public subnets
resource "aws_route_table" "route_table_public" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags   = local.common_tags
}

# Route table for private subnets
resource "aws_route_table" "route_table_private" {
  vpc_id      = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags   = local.common_tags
}

# Route table for publis subnet - assocoate to the public subnet
resource "aws_route_table_association" "route_table_association_public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.route_table_public.id
}

# Route table for private subnet - assocoate to the private subnet
resource "aws_route_table_association" "route_table_association_private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.route_table_private.id
}

# Security Groups [web, db, alb]
# sg web
resource "aws_security_group" "sg-web" {
  name        = "sg_web"
  description = "Security group for public web servers with HTTP/80 and SSH/22 ports open [inbound] and all open [outbound]"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# sg db
resource "aws_security_group" "sg-db" {
  name        = "sg_db"
  description = "Security group for private db servers with SSH/22 port open within VPC [inbound], and all open [outbound]"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# sg ALB
resource "aws_security_group" "sg-lb" {
  name        = "sg_lb"
  description = "Security group for application load balancer with HTTP/80 open [inbound] and all open [outbound]"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Instances [web, db]
# Web instances
resource "aws_instance" "web" {
  count                  = local.public_instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.*.id[count.index]
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg-web.id]
  user_data_base64       = base64encode(local.user_data)
  tags = local.common_tags


  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem

  }
}

# DB instances
resource "aws_instance" "db" {
  count                  = local.private_instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[count.index].id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg-db.id]
  tags = local.common_tags

}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb-ops"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-lb.id]
  subnets            = aws_subnet.public.*.id

  tags = local.common_tags
}

# Target group
resource "aws_lb_target_group" "target-group" {
  name         = "target-group"
  port         = 80
  protocol     = "HTTP"
  vpc_id       = aws_vpc.vpc.id
  target_type  = "instance"
  health_check {
      enabled             = lookup(var.health_check, "enabled", true)
      interval            = lookup(var.health_check, "interval", 30)
      path                = lookup(var.health_check, "path", "/")
      port                = lookup(var.health_check, "port", 80)
      healthy_threshold   = lookup(var.health_check, "healthy_threshold", 5)
      unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 2)
      timeout             = lookup(var.health_check, "timeout", 5)
      protocol            = lookup(var.health_check, "protocol", "HTTP")
    }
}

# Attach targets to target group 
resource "aws_lb_target_group_attachment" "targets_to_target_group_attach" {
  count            = local.public_instance_count
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.web.*.id[count.index]
  port             = 80
}

# Set ALB and targe group in the listener
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}

# ##################################################################################
# # RESOURCES
# ##################################################################################

# # EIP 
# resource "aws_eip" "nat" {
#   count  = var.public_subnet_count
#   vpc    = true
#   tags   = merge(var.tags, var.aws_eip_tags)    
# }

# # Nat GW
# resource "aws_nat_gateway" "nat-gw" {
#   count         = var.public_subnet_count
#   allocation_id = aws_eip.nat.*.id[count.index]
#   subnet_id     = aws_subnet.public.*.id[count.index]

#   tags          = merge(var.tags, var.nat_gw_tags)      
#   depends_on    = [aws_internet_gateway.gw]
# }

# # Route table for public subnets
# resource "aws_route_table" "route_table_public" {
#   vpc_id       = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags         = merge(var.tags, var.rt_public_tags)
# }

# # Route table for private subnets
# resource "aws_route_table" "route_table_private" {
#   count       = var.private_subnet_count
#   vpc_id      = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.nat-gw.*.id[count.index]
#   }

#   tags         = merge(var.tags, var.rt_private_tags)
# }

# # Route table for public subnet - associate to the public subnet
# resource "aws_route_table_association" "route_table_association_public" {
#   count          = var.public_subnet_count
#   subnet_id      = aws_subnet.public.*.id[count.index]
#   route_table_id = aws_route_table.route_table_public.id
# }

# # Route table for private subnet - associate to the private subnet
# resource "aws_route_table_association" "route_table_association_private" {
#   count          = var.private_subnet_count
#   subnet_id      = aws_subnet.private.*.id[count.index]
#   route_table_id = aws_route_table.route_table_private.*.id[count.index]
# }

# # Security Groups [web, db, alb]
# # sg web
# resource "aws_security_group" "sg-web" {
#   name        = "sg_web"
#   description = "Security group for public web servers with HTTP/80 and SSH/22 ports open [inbound] and all open [outbound]"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags         = merge(var.tags, var.sg_web_tags) 
# }

# # sg db
# resource "aws_security_group" "sg-db" {
#   name        = "sg_db"
#   description = "Security group for private db servers with SSH/22 port open within VPC [inbound], and all open [outbound]"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags         = merge(var.tags, var.sg_db_tags)  
# }

# # sg ALB
# resource "aws_security_group" "sg-lb" {
#   name        = "sg_lb"
#   description = "Security group for application load balancer with HTTP/80 open [inbound] and all open [outbound]"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags          = merge(var.tags, var.sg_alb_tags)   
# }

# # Instances [web, db]
# # Web instances
# resource "aws_instance" "web" {
#   count                  = var.public_instance_count
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = var.instance_type
#   subnet_id              = aws_subnet.public.*.id[count.index]
#   key_name               = aws_key_pair.key_pair.key_name
#   vpc_security_group_ids = [aws_security_group.sg-web.id]
#   user_data_base64       = base64encode(var.user_data)
#   iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
#   tags                   = merge(var.tags, var.web_tags)   


#   connection {
#     type        = "ssh"
#     host        = self.public_ip
#     user        = "ubuntu"
#     private_key = tls_private_key.key_pair.private_key_pem

#   }

#   provisioner "file" {
#     content     = <<EOF
# access_key =
# secret_key =
# security_token =
# use_https = True
# bucket_location = US

# EOF
#     destination = "/home/ubuntu/.s3cfg"
#   }

#   provisioner "file" {
#     content = <<EOF
# /var/log/nginx/*log {
#     hourly
#     rotate 48
#     missingok
#     compress
#     sharedscripts
#     postrotate
#     endscript
#     lastaction
#         INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
#         sudo /usr/local/bin/s3cmd sync /var/log/nginx/ --exclude error* --exclude *.log s3://${var.bucket}/nginx/$INSTANCE_ID/
#     endscript
# }

# EOF

#     destination = "/home/ubuntu/nginx"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo cp /home/ubuntu/nginx /etc/logrotate.d/nginx-new"
      

#     ]
#   }



# }

# # DB instances
# resource "aws_instance" "db" {
#   count                  = var.private_instance_count
#   ami                    = data.aws_ami.ubuntu.id
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private[count.index].id
#   key_name               = aws_key_pair.key_pair.key_name
#   vpc_security_group_ids = [aws_security_group.sg-db.id]
#   tags                   = merge(var.tags, var.db_tags)   

# }

# # Application Load Balancer
# resource "aws_lb" "alb" {
#   name               = "alb-ops"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.sg-lb.id]
#   subnets            = aws_subnet.public.*.id

#   tags                   = merge(var.tags, var.alb_tags)   
# }

# # Target group
# resource "aws_lb_target_group" "target-group" {
#   name         = "target-group"
#   port         = 80
#   protocol     = "HTTP"
#   vpc_id       = aws_vpc.vpc.id
#   target_type  = "instance"
#   health_check {
#       enabled             = lookup(var.health_check, "enabled", true)
#       interval            = lookup(var.health_check, "interval", 30)
#       path                = lookup(var.health_check, "path", "/")
#       port                = lookup(var.health_check, "port", 80)
#       healthy_threshold   = lookup(var.health_check, "healthy_threshold", 5)
#       unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 2)
#       timeout             = lookup(var.health_check, "timeout", 5)
#       protocol            = lookup(var.health_check, "protocol", "HTTP")
#     }
  
#   stickiness {
#     type            = "lb_cookie"
#     cookie_duration = var.stickiness_cookie_duration
#     enabled         = true
#   }
  
#   tags              = merge(var.tags, var.tg_tags) 
# }

# # Attach targets to target group 
# resource "aws_lb_target_group_attachment" "targets_to_target_group_attach" {
#   count            = var.public_instance_count
#   target_group_arn = aws_lb_target_group.target-group.arn
#   target_id        = aws_instance.web.*.id[count.index]
#   port             = 80
# }

# # Set ALB and targe group in the listener
# resource "aws_lb_listener" "lb-listener" {
#   load_balancer_arn = aws_lb.alb.arn
#   port              = "80"
#   protocol          = "HTTP"
  

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target-group.arn
#   } 
# }




##################################################################################
# RESOURCES
##################################################################################

# # EIP 
# resource "aws_eip" "nat" {
#   count  = var.public_subnet_count
#   vpc    = true
#   tags   = merge(var.tags, var.aws_eip_tags)    
# }

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

  tags         = merge(var.tags, var.sg_web_tags) 
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

  tags         = merge(var.tags, var.sg_db_tags)  
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

  tags          = merge(var.tags, var.sg_alb_tags)   
}

# Instances [web, db]
# Web instances
resource "aws_instance" "web" {
  count                  = var.public_instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.*.id[count.index]
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg-web.id]
  user_data_base64       = base64encode(var.user_data)
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
  tags                   = merge(var.tags, var.web_tags)   


  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem

  }

  provisioner "file" {
    content     = <<EOF
access_key =
secret_key =
security_token =
use_https = True
bucket_location = US

EOF
    destination = "/home/ubuntu/.s3cfg"
  }

  provisioner "file" {
    content = <<EOF
/var/log/nginx/*log {
    hourly
    rotate 48
    missingok
    compress
    sharedscripts
    postrotate
    endscript
    lastaction
        INSTANCE_ID=`curl --silent http://169.254.169.254/latest/meta-data/instance-id`
        sudo /usr/local/bin/s3cmd sync /var/log/nginx/ --exclude error* --exclude *.log s3://${var.bucket}/nginx/$INSTANCE_ID/
    endscript
}

EOF

    destination = "/home/ubuntu/nginx"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /home/ubuntu/nginx /etc/logrotate.d/nginx-new"
      

    ]
  }

}

# DB instances
resource "aws_instance" "db" {
  count                  = var.private_instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private[count.index].id
  key_name               = aws_key_pair.key_pair.key_name
  vpc_security_group_ids = [aws_security_group.sg-db.id]
  tags                   = merge(var.tags, var.db_tags)   

}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "alb-ops"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-lb.id]
  subnets            = aws_subnet.public.*.id

  tags                   = merge(var.tags, var.alb_tags)   
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
  
  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.stickiness_cookie_duration
    enabled         = true
  }
  
  tags              = merge(var.tags, var.tg_tags) 
}

# Attach targets to target group 
resource "aws_lb_target_group_attachment" "targets_to_target_group_attach" {
  count            = var.public_instance_count
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
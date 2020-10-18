
##################################################################################
# PROVIDERS
##################################################################################

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.10.0"
    }
  }
}

provider "aws" {
  # Using aws default credentials file instead of aws_access_key and aws_secret_key
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
  region     = var.region
}

##################################################################################
# DATA
##################################################################################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  
   filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
    }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ebs_default_kms_key" "current" {}

data "aws_availability_zones" "available" {}

##################################################################################
# RESOURCES
##################################################################################

# This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}

resource "aws_security_group" "allow_ssh_and_http" {
  name        = "nginx_sg"
  description = "Allow ports for nginx instances"
  vpc_id      = aws_default_vpc.default.id

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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.medium"
  availability_zone      = data.aws_availability_zones.available.names[count.index % var.instance_count]
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_http.id]
  tags = merge(local.common_tags, { Name = "nginx-${count.index}" })

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.private_key_path)

  }

  root_block_device {
    volume_type = "standard"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = "10"
    encrypted = true
    kms_key_id = data.aws_ebs_default_kms_key.current.key_arn
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install nginx -y",
      "echo '<html><head><title>OpsSchool Rules</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">OpsSchool Rules</span></span></p></body></html>' | sudo tee /var/www/html/index.nginx-debian.html"
    ]
  }
}

##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns" {

  value = [aws_instance.nginx.*.public_dns]

}

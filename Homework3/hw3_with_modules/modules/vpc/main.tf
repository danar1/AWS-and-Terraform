
##################################################################################
# RESOURCES
##################################################################################

# vpc
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block

  tags       = merge(var.tags, var.vpc_tags)
}

# public subnets
resource "aws_subnet" "public" {
  count                   = local.public_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index + 1)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags                    = merge(var.tags, var.public_subnet_tags)
}

# private subnets
resource "aws_subnet" "private" {
  count                   = local.private_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, (count.index + 1) * 100)
  availability_zone       = element(var.azs, count.index)

  tags                    = merge(var.tags, var.private_subnet_tags)
}

# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags   = merge(var.tags, var.gw_tags)
}

# EIP 
resource "aws_eip" "nat" {
  count  = local.public_subnet_count
  vpc    = true
  tags   = merge(var.tags, var.eip_tags)  
}

# Nat GW
resource "aws_nat_gateway" "nat-gw" {
  count         = local.public_subnet_count
  allocation_id = aws_eip.nat.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]

  tags          = merge(var.tags, var.nat_tags)   
  depends_on    = [aws_internet_gateway.gw]
}

# Route table for public subnets
resource "aws_route_table" "route_table_public" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags         = merge(var.tags, var.public_route_table_tags)  
}

# Route table for private subnets
resource "aws_route_table" "route_table_private" {
  count       = local.private_subnet_count
  vpc_id      = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.*.id[count.index]
  }

  tags         = merge(var.tags, var.private_route_table_tags)    
}

# Route table for publis subnet - associate to the public subnet
resource "aws_route_table_association" "route_table_association_public" {
  count          = local.public_subnet_count
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.route_table_public.id
}

# Route table for private subnet - associate to the private subnet
resource "aws_route_table_association" "route_table_association_private" {
  count          = local.private_subnet_count
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.route_table_private.*.id[count.index]
}


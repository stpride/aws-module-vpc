
resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = {
    Name        = var.name
    Environment = var.environment
    Provisioner = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name         = var.name
    Environment  = var.environment
    Provisioner  = "Terraform"
  }
}

resource "aws_eip" "nat" {
  count = length(var.zones)
  vpc   = true

  tags = {
    Name         = "NAT-${var.zones[count.index]}"
    Environment  = var.environment
    Provisioner  = "Terraform"
  }
}

module "public_subnet" {
  source = "git::https://github.com/stpride/aws-module-public-subnet.git"
  name   = var.name
  cidrs  = var.public
  zones  = var.zones
  vpc_id = aws_vpc.vpc.id
  igw_id = aws_internet_gateway.igw.id
  env    = var.environment
}

resource "aws_nat_gateway" "natgw" {
  count         = length(var.zones)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(module.public_subnet.subnet_ids, count.index)
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name         = "main"
    Environment  = var.environment
    Provisioner  = "Terraform"
  }
}

module "private_subnet" {
  source = "git::https://github.com/stpride/aws-module-private-subnet.git"
  name   = var.name
  cidrs  = var.private
  zones  = var.zones
  vpc_id = aws_vpc.vpc.id
  env    = var.environment
  nats   = aws_nat_gateway.natgw.*.id
}


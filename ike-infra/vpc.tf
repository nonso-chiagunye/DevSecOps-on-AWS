resource "aws_vpc" "ike_vpc" {
  cidr_block       = "192.168.0.0/16"
  enable_dns_support = true 
  enable_dns_hostnames = true 

  tags = {
    Name = var.vpc
  }
}

resource "aws_subnet" "ike_private_subnet01" {
  vpc_id                  = aws_vpc.ike_vpc.id
  cidr_block              = "192.168.10.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "ike-private-subnet01"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "ike_private_subnet02" {
  vpc_id                  = aws_vpc.ike_vpc.id
  cidr_block              = "192.168.20.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "ike-private-subnet02"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "ike_public_subnet01" {
  vpc_id                  = aws_vpc.ike_vpc.id
  cidr_block              = "192.168.40.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "ike-public-subnet01"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "ike_public_subnet02" {
  vpc_id                  = aws_vpc.ike_vpc.id
  cidr_block              = "192.168.30.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1b"

  tags = {
    Name = "ike-public-subnet02"
    "kubernetes.io/role/elb" = "1"
  }
}
resource "aws_internet_gateway" "ike_igw" {
  vpc_id = aws_vpc.ike_vpc.id

  tags = {
    Name = "ike-igw"
  }
}

resource "aws_route_table" "ike_route_public" {
  vpc_id = aws_vpc.ike_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ike_igw.id
  }

  tags = {
    Name = "ike-route-public"
  }
}


resource "aws_route_table_association" "public_subnet_assoc01" {
  subnet_id      = aws_subnet.ike_public_subnet01.id
  route_table_id = aws_route_table.ike_route_public.id
}

resource "aws_route_table_association" "public_subnet_assoc02" {
  subnet_id      = aws_subnet.ike_public_subnet02.id
  route_table_id = aws_route_table.ike_route_public.id
}


resource "aws_eip" "ike_eip" {
  # vpc = true
  domain = "vpc"
}

resource "aws_nat_gateway" "ike_ngw" {
  allocation_id = aws_eip.ike_eip.id
  subnet_id     = aws_subnet.ike_public_subnet01.id
  # connectivity_type = "private" 
  depends_on    = [aws_internet_gateway.ike_igw]
}

resource "aws_route_table" "ike_route_private" {
  vpc_id = aws_vpc.ike_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ike_ngw.id
  }

  tags = {
    Name = "ike-route-private"
  }
}

resource "aws_route_table_association" "ike_private_assoc01" {
  subnet_id      = aws_subnet.ike_private_subnet01.id
  route_table_id = aws_route_table.ike_route_private.id
}

resource "aws_route_table_association" "ike_private_assoc02" {
  subnet_id      = aws_subnet.ike_private_subnet02.id
  route_table_id = aws_route_table.ike_route_private.id
}
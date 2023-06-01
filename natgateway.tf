resource "aws_eip" "ngaz1_eip" {
  vpc = true

}

resource "aws_eip" "ngaz2_eip" {
  vpc = true

}

# create nat gateways
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.ngaz1_eip.id
  subnet_id     = aws_subnet.public_subnet_az1.id

  tags = {
    Name = " nat gateway az1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}


resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.ngaz2_eip.id
  subnet_id     = aws_subnet.public_subnet_az2.id

  tags = {
    Name = " nat gateway az2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet_gateway]
}


#Create a private route table
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = " private route table az1"
  }
}

resource "aws_route_table" "private_route_table_az2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = " private route table az2"
  }
}


resource "aws_route_table_association" "private_app_subnet_az1" {
  subnet_id      = aws_subnet.private_app_subnet_az1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

resource "aws_route_table_association" "private_data_subnet_az1" {
  subnet_id      = aws_subnet.private_data_subnet_az1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

resource "aws_route_table_association" "private_app_subnet_az2" {
  subnet_id      = aws_subnet.private_app_subnet_az2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}

resource "aws_route_table_association" "private_data_subnet_az2" {
  subnet_id      = aws_subnet.private_data_subnet_az2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}

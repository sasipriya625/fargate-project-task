provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "VPC_Task" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.VPC_Task.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.VPC_Task.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.VPC_Task.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.VPC_Task.id
  cidr_block = "10.0.3.0/24"
}

resource "aws_eip" "sasi-eip" {
  vpc   = true
 }

 resource "aws_nat_gateway" "sasi_nat" {
  allocation_id = aws_eip.sasi-eip.id
  subnet_id = aws_subnet.public_subnet.id
 }

resource "aws_internet_gateway" "Priya_IGW" {
  vpc_id    = aws_vpc.VPC_Task.id
}

resource "aws_route_table" "sasi_RT1" {
  vpc_id = aws_vpc.VPC_Task.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Priya_IGW.id
  }
}

resource "aws_route_table" "sasi_RT2" {
  vpc_id = aws_vpc.VPC_Task.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.sasi_nat.id
  }
}

resource "aws_route_table_association" "sasi_RT_Association1" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.sasi_RT1.id
}

resource "aws_route_table_association" "sasi_RT_Association2" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.sasi_RT2.id
}


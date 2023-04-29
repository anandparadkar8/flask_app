resource "aws_vpc" "project-vpc" {
  cidr_block = var.cidr_vpc
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "pub-subnet-1" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnet_cidrs_public
  availability_zone = var.availability_zone_1
  tags = {
    Name = "public-sub-1"
  }
}
resource "aws_subnet" "pub-subnet-2" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnet_cidrs_public-2
  availability_zone = var.availability_zone_2
  tags = {
    Name = "public-sub-2"
  }
}

resource "aws_subnet" "pr-subnet-1" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnet_cidrs_private
  availability_zone = var.availability_zone_1
  tags = {
    Name = "private-sub-1"
  }
}
resource "aws_subnet" "pr-subnet-2" {
  vpc_id            = aws_vpc.project-vpc.id
  cidr_block        = var.subnet_cidrs_private-2
  availability_zone = var.availability_zone_2
  tags = {
    Name = "private-sub-2"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.project-vpc.id
}

resource "aws_nat_gateway" "NGW-1" {
  allocation_id = aws_eip.eip_nat-1.id

  subnet_id = aws_subnet.pub-subnet-1.id
}

resource "aws_nat_gateway" "NGW-2" {
  allocation_id = aws_eip.eip_nat-2.id

  subnet_id = aws_subnet.pub-subnet-2.id
}

resource "aws_eip" "eip_nat-1" {
  depends_on = [aws_internet_gateway.IGW]
}

resource "aws_eip" "eip_nat-2" {
  depends_on = [aws_internet_gateway.IGW]
}
resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    "Name" = "public_RT"
  }
}

resource "aws_route_table_association" "public_01_RT_asso" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_02_RT_asso" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table" "private_RT-1" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NGW-1.id
  }
  tags = {
    "Name" = "private_RT01"
  }
}
resource "aws_route_table" "private_RT-2" {
  vpc_id = aws_vpc.project-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NGW-1.id
  }
  tags = {
    "Name" = "private_RT02"
  }
}

resource "aws_route_table_association" "private01_RT_asso" {
  subnet_id      = aws_subnet.pr-subnet-2.id
  route_table_id = aws_route_table.private_RT-1.id
}
resource "aws_route_table_association" "private02_RT_asso" {
  subnet_id      = aws_subnet.pr-subnet-1.id
  route_table_id = aws_route_table.private_RT-2.id
}
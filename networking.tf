data "aws_availability_zones" "available" {}
//vpc created
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform_project_vpc"
  }
  lifecycle {
    create_before_destroy = true
  }
}
//public subnet created
resource "aws_subnet" "terraform-public-subnet" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform_public_subnet"
  }
}
//private subnet
resource "aws_subnet" "terraform-private-subnet" {
  count                   = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "terraform_private_subnet"
  }
}
//igw attach
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}
//public route table create
resource "aws_route_table" "terraform-public-RT" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "terraform-public-RouteTable"
  }
}
//private route table create
resource "aws_route_table" "terraform-private-RT" {
  vpc_id = aws_vpc.main.id

  /* route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  } */

  tags = {
    Name = "terraform-private-RouteTable"
  }
}
//public route table association
resource "aws_route_table_association" "public-RT-association" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.terraform-public-subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform-public-RT.id
}
//private route table association
resource "aws_route_table_association" "private-RT-association" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.terraform-private-subnet.*.id[count.index]
  route_table_id = aws_route_table.terraform-private-RT.id
}
//security group
resource "aws_security_group" "terraform-sg" {
  name        = "allow_subnet_instance"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
//port 22 allowed
resource "aws_security_group_rule" "ssh_allow" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.terraform-sg.id
}
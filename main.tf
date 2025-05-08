#####################################
# VPC
#####################################
resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name   = "${var.ClusterBaseName}-vpc"
    Create = "terraform"
  }
}
#####################################
# サブネット
#####################################
resource "aws_subnet" "public_subnet1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-northeast-1a"
  
  map_public_ip_on_launch = true

  tags = {
    Name   = "public-subnet1a"
    Create = "terraform"
  }
}
resource "aws_subnet" "public_subnet1c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-northeast-1c"

  map_public_ip_on_launch = true

  tags = {
    Name   = "public-subnet1c"
    Create = "terraform"
  }
}
resource "aws_subnet" "public_subnet1d" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "ap-northeast-1d"
  
  map_public_ip_on_launch = true
  
  tags = {
    Name   = "public-subnet1d"
    Create = "terraform"
  }
}

resource "aws_subnet" "private_subnet1a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "ap-northeast-1a"
  
  tags = {
    Name   = "private-subnet1a"
    Create = "terraform"
  }
}

resource "aws_subnet" "private_subnet1c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "ap-northeast-1c"
  
  tags = {
    Name   = "private-subnet1c"
    Create = "terraform"
  }
}

resource "aws_subnet" "private_subnet1d" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "192.168.5.0/24"
  availability_zone = "ap-northeast-1d"
  
  tags = {
    Name   = "private-subnet1d"
    Create = "terraform"
  }
}

#####################################
# ルートテーブル
#####################################
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name   = "public-rt"
    Create = "terraform"
  }
}
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet1a.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet1c.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet1d.id
  route_table_id = aws_route_table.public_route_table.id
}

#####################################
# インターネットゲートウェイ
#####################################
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name   = "my-igw"
    Create = "terraform"
  }
}

#####################################
# Security Group
#####################################
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  description = "Security Group for RDS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    cidr_blocks = aws_subnet.public_subnet1a.cidr_block
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = aws_subnet.public_subnet1c.cidr_block
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  ingress {
    cidr_blocks = aws_subnet.public_subnet1d.cidr_block
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "rds-security-group"
    Create = "terraform"
  }
}

#####################################
# 踏み台EC2
#####################################
resource "aws_instance" "my_instance" {
  ami           = "ami-00d101850e971728d" # ap-northeast-1, SSD, Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet1a
  #今度書く
}

#####################################
# RDS
#####################################
#今度書く
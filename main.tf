###########################
# 1. VPC + Subnet
###########################

resource "aws_vpc" "t2_vpc" {
  cidr_block           = "10.0.0.0/23"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "t2-vpc"
  }
}

resource "aws_subnet" "t2_subnet" {
  vpc_id                  = aws_vpc.t2_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "t2-subnet"
  }
}

###########################
# 2. Internet Gateway
###########################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.t2_vpc.id

  tags = {
    Name = "t2-igw"
  }
}

###########################
# 3. Route Table + Route
###########################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.t2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "subnet_rt_assoc" {
  subnet_id      = aws_subnet.t2_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

###########################
# 4. Security Group
###########################

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_sg"
  description = "Allow SSH only"
  vpc_id      = aws_vpc.t2_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowSSH"
  }
}

###########################
# 5. EC2 Key + Instance
###########################

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.t2_subnet.id
  key_name               = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Terraform-EC2"
  }
}
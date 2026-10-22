provider "aws" {
  region = "ap-south-1"
}

# Dynamically fetch the latest Amazon Linux 2023 AMI for ap-south-1
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "nexvion-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "nexvion-public-subnet"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.large"
  subnet_id     = aws_subnet.public.id
  tags = {
    Name = "nexvion-devops-server"
  }
}

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
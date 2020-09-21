provider "aws" {
 region = "us-east-1"
}


resource "aws_vpc" "vpc" {
 cidr_block = "10.0.0.0/16"
 enable_dns_support  = true
 enable_dns_hostnames = true
 lifecycle {
    prevent_destroy = true
  }
 tags = {
  Environment = "production"
 }
}

resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "subnet_public_a" {
 vpc_id = aws_vpc.vpc.id
 cidr_block = "10.0.1.0/24"
 map_public_ip_on_launch = "true"
 availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_public_b" {
 vpc_id = aws_vpc.vpc.id
 cidr_block = "10.0.2.0/24"
 map_public_ip_on_launch = "true"
 availability_zone = "us-east-1b"
}

resource "aws_route_table" "rtb_public" {
 vpc_id = aws_vpc.vpc.id
route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
}

resource "aws_route_table_association" "rta_subnet_public_a" {
 subnet_id   = aws_subnet.subnet_public_a.id
 route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "rta_subnet_public_b" {
 subnet_id   = aws_subnet.subnet_public_b.id
 route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "web_rules" {
 name = "websg"
  vpc_id=aws_vpc.vpc.id
 egress {
  to_port=0
  protocol=-1
  from_port=0
  cidr_blocks = ["0.0.0.0/0"]
 }
 ingress {
  from_port  = 80
  to_port   = 80
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
}
resource "aws_security_group" "ssh_rules" {
 name = "sshsg"
  vpc_id=aws_vpc.vpc.id
 ingress {
  from_port  = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }
}


#resource "aws_s3_bucket" "cts-statebucket" {
    #bucket = "cts-statebucket"
    #acl    = "public-read"
#}

terraform {
  backend "s3" {
    bucket = "cts-statebucket"
    key    = "s3://cts-statebucket/Infra-1/terraform.tfstate"
    region = "us-east-1"
  }
}

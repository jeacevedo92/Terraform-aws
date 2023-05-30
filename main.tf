provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

//NETWORKING 
//create a new AWS VPC
resource "aws_vpc" "nginx-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"
}

//Create a public subnet for the VPC we created above
resource "aws_subnet" "subnet-public-1" {
  vpc_id                  = aws_vpc.nginx-vpc.id    // Referencing the id of the VPC from abouve code block
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"                  // Makes this a public subnet
  availability_zone       = "us-east-2a"
}

//Create an Internet Gateway for the VPC. The VPC require an IGW to communicate over the internet
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = aws_vpc.nginx-vpc.id
}

//Create a custom route table for the VPC
resource "aws_route_table" "prod-public-crt" {
  vpc_id = aws_vpc.nginx-vpc.id
  route {
    cidr_block = "0.0.0.0/0"                      //associated subnet can reach everywhere
    gateway_id = aws_internet_gateway.prod-igw.id //CRT uses this IGW to reach internet
  }
tags = {
    Name = "prod-public-crt"
  }
}

//Associate the route table with the public subnet
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = aws_subnet.prod-subnet-public-1.id
  route_table_id = aws_route_table.prod-public-crt.id
}

//
resource “aws_instance” test-instance” {
  ami = ””
  instance_type = ”t2.micro”
  tags= {
    Name = ”practica1”
    Environment = “”Dev
  }
}


//Create a security group to allow SSH access and HTTP access
resource "aws_security_group" "ssh-allowed" {
vpc_id = aws_vpc.nginx-vpc.id
egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
cidr_blocks = ["0.0.0.0/0"] // Ideally best to use your machines' IP. However if it is dynamic you will need to change this in the vpc every so often. 
  }
ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "example" {
  # ...
  lifecycle {
    prevent_destroy = true # no destruir cuando se aplique terraform destroy
  }
  timeouts {
    create = "60m"
    delete = "2h"
  }
}m

//Create a variables.tf file and add the following variables

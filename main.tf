# # Terraform init -will download any required package

# # Provider aws
provider "aws" {
# which region
    region = var.region
}
# init with terraform
# what do we want to launch
# Automate the process of creating EC2 instance

#  My VPC
resource "aws_vpc" "eng103a_latif_tf_vpc" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"


    tags = {
        Name = "103a_latif_terraform_vpc"
    }
}
# my subnet
resource "aws_subnet" "eng103a_latif_tf_vpc_public" {
    vpc_id     = "${aws_vpc.eng103a_latif_tf_vpc.id}"
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-1a"
    
    tags = {
        Name = "eng103a_latif_tf_vpc_publicSN"
    }
}

# my second subnet
resource "aws_subnet" "eng103a_latif_tf_vpc_public-2" {
    vpc_id     = "${aws_vpc.eng103a_latif_tf_vpc.id}"
    cidr_block = "10.0.14.0/24"
    map_public_ip_on_launch = true
    availability_zone = "eu-west-1b"
    
    tags = {
        Name = "eng103a_latif_tf_vpc_public-2"
    }
}
resource "aws_internet_gateway" "eng103a_latif_tf_igw" {
    vpc_id = "${aws_vpc.eng103a_latif_tf_vpc.id}"
    
    tags = {
        Name = "eng103a_latif_tf_igw"
    }
}


resource "aws_route_table" "eng103a_latif_tf_rt" {
    vpc_id = "${aws_vpc.eng103a_latif_tf_vpc.id}"
 
route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eng103a_latif_tf_igw.id
    }
 
    tags = {
        Name = "eng103a_latif_tf_rt"
  }
}

# resource "aws_route_table_association" "eng103a_latif_tf_subnet_association" {
#   route_table_id = aws_route_table.eng103a_latif_tf_rt.id
#   subnet_id = aws_subnet.eng103a_latif_tf_vpc_publicSN.id
# }



resource "aws_security_group" "latif_sg_app" {
  vpc_id = "${aws_vpc.eng103a_latif_tf_vpc.id}"
  
  ingress {
    description      = "access to the app"
    from_port        =  80
    to_port          =  80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  # ssh access
  ingress {
    description      = "ssh access"
    from_port        =  22
    to_port          =  22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
 # Allow port 3000 from anywhere
  ingress {
    from_port        =  3000
    to_port          =  3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
 
    }
 
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"]
  }
 
tags = {
    Name = "eng103a_latif_tf_sg_app"
    }
}
 
# # name of the resource
resource "aws_instance" "latif_tf_app" {
# security group
vpc_security_group_ids = ["${aws_security_group.latif_sg_app.id}"]
 # subnet id   
  subnet_id = "${aws_subnet.eng103a_latif_tf_vpc_public.id}"
# which AMI to use
  ami = "ami-0765af24323e4f33c"
# what type of instace
  instance_type = var.instance_type
# do you want public IP
  associate_public_ip_address = true

# What is the name of your instance
  tags = {
    Name = var.app_instance_name 
  }
  #key name
  key_name = var.key_pair_name
}


 


# Terraform init -will download any required package

# Provider aws
provider "aws" {
  

# which region
    region = "eu-west-1"
}

# init with terraform

# what do we want to launch
# Automate the process of creating EC2 instance

# name of the resource
resource "aws_instance" "latif_tf_app" {
  

# which AMI to use
  ami = "ami-07d8796a2b0f8d29c"
# what type of instace
  instance_type = "t2.micro"
# do you want public IP
  associate_public_ip_address = true

# What is the name of your instance
  tags = {
    Name = "v103a_latif_tf_app"
  }
}
# 
  GNU nano 5.9                       README.md
# Infrastrcutre as code with terraform
## What is Terraform
### Terraform architecture
#### Terraform deafult file/folder structure
##### .gitignore
###### AWS keys with Terraform security

Install
- Follow link 
- https://chocolatey.org/install
- Install Terraform with `choco install terraform`
- Check with  `terraform --version`
- Powershell ENV refresh command refreshenv

![terraform_with_ansible-new](https://user-images.githubusercontent.com/98215575/155320606-e7970ac7-b057-4dbb-b6eb-c923c3979642.jpg)

- Terraform commands
- `terraform init`  initialise Terraform
- `terraform plan` Checks the script,lets you preview the changes that Terraform plans to make to your infrastructure.
- `terraform apply` Implement the script,  executes the actions proposed in a Terraform plan
- `terraform destroy` to delete everything

-Terraform file/folder strcture
- `.tf` extention - runner file -`main.tf`
- Apply `DRY`
  
### Set up AWS Keys as an ENV in windows machine
- `AWS_ACCESS_KEY_ID` for aws access keys
- `AWS_SECRET_ACCESS_KEY` for aws secret 
- `click windows key` - `type env` - `edit the system env variable`
-  Under User variables click new  
- Add the 2 new variables
-  Open git bash terminal and check if terraform is present with 
- `terraform --version`
Run:
`terraform init` 
`terraform plan`
- If terraform commands do not work
- open VS code as admin
- If that does not work open git bash as admin
- And enter te terraform commands again

Install terraform plugins on VS code to make writing `.tf` files easier
For aws install

Create `main.tf` 
Add `resources`
- `terraform init`
- `terraform plan` - any syntax errors or 
- `terraform apply`
### SSH into instance
- Using key already created on aws (create a new one if needed)
- Now add this into main file or make it a variable and add it to `variable.tf`
- key_name = "NAME OF KEYPAIR"
- Run the commands to start EC2
- After initalised on AWS go connect and get the ssh command
- Should now be able to SSH into EC2 instance
  
### Creating VPC using Terraform 

- VPC requirements - Name - CIDR Block - Tags
```
resource "aws_vpc" "Name" {
    cidr_block = var.cidr_block
    instance_tenancy = "default"


    tags = {
        Name = "103a_latif_terraform_vpc"
    }
}
```
### Creating Subnet in VPC using Terraform -
- Subnet requirements - Name - VPC ID - CIDR Block - Tags 
  
```
resource "aws_subnet" "Subnet name" {
    vpc_id     = "${pc.id}" # ${} worked for me 
    cidr_block = "10.0.11.0/24"
    map_public_ip_on_launch = true
    availability_zone = var.avail_zone
    
    tags = {
        Name = "Subnetname"
    }
}
```
### Internet Gateway
```
- Internet Gateway requirements - VPC ID, Tags
  
resource "aws_internet_gateway" "name" {
    vpc_id = "${vpc.id}"
    
    tags = {
        Name = "name"
    }
}
```
### Route table
- Route Table requirements - VPC ID, CIDR Block, Gateway ID, Tags
```  
resource "aws_route_table" "name" {
    vpc_id = "${vpc.id}"
 
route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = _igw.id
    }
 
    tags = {
        Name = "name"
  }
}
### Attempted to use this to associate the route table and subnet. Had to manually do this.
```
# resource "aws_route_table_association" "eng103a_latif_tf_subnet_association" {
#   route_table_id = aws_route_table.eng103a_latif_tf_rt.id
#   subnet_id = aws_subnet.eng103a_latif_tf_vpc_publicSN.id
# }
```
```
### Security group
- Subnet requirements - Name - VPC ID - CIDR Block - Tags
```  
resource "aws_security_group" "name" {
  vpc_id = "${vpc.id}"
  
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
    Name = "name"
    }
}
```
### Create an instance on AWS - Ansible controller
- AMI made for AWS controller we can start it by using Terraform and adding the AMI id
- To launch the app we created on Ansible. We created an AMI from that app. We then used the AMI in the below script.
```
# # name of the resource
resource "aws_instance" "name" {
# security group
vpc_security_group_ids = ["${nameid}"]
 # subnet id   
  subnet_id = "${ubnet.id}"
# which AMI to use
  ami = var.app_ami_id
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

```

- The script runs from top to bottom. So all the resources can be run at once. If they are in the correct order'
- So the script can be then run with `terraform plan` and `terraforom apply` 
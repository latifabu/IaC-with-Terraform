  GNU nano 5.9                       README.md
# Infrastrcutre as code with terraform
## What is Terraform
### Terraform architecture
#### Terraform deafult file/folder structure
##### .gitignore
###### AWS keys with Terraform security

![terraform_with_ansible-new](https://user-images.githubusercontent.com/98215575/155320606-e7970ac7-b057-4dbb-b6eb-c923c3979642.jpg)

- Terraform commands
- `terraform init` T initialise Terraform
- `terraform plan` checks the script
- `terraform apply` implement the script
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
  
Run:
`terraform init` 
`terraform plan`
- If terraform commands do not work
- open VS code as admin
- If that does not work open git bash as admin
- And enter te terraform commands again
  

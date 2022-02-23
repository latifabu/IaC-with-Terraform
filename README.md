  GNU nano 5.9                       README.md
# Infrastrcutre as code with terraform
## What is Terraform
### Terraform architecture
#### Terraform deafult file/folder structure
##### .gitignore
###### AWS keys with Terraform security

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
- Click new user 
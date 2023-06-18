###### task
Create VPC for multi staging and manage the VPC crteation using true/false condition.


###### Initialize the Terraform project

terraform init

###### Create the dev VPC if vpc_flag is true
terraform workspace new dev
terraform apply -var-file=dev.tfvars

###### Switch to staging workspace and create the staging VPC if vpc_flag is true
terraform workspace new staging
terraform apply -var-file=staging.tfvars

###### Switch to prod workspace and create the prod VPC if vpc_flag is true
terraform workspace new prod
terraform apply -var-file=prod.tfvars


In this example, the vpc_flag variable is used to conditionally create the VPC resource. If vpc_flag is set to true in the respective .tfvars file, the VPC resource will be created. Otherwise, it will be skipped (count = 0). The stage variable is used to define the stage for each workspace, and it can be customized in the respective .tfvars files.
# file updated

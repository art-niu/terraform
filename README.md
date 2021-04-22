# Initialize Terraform Workspace
terraform init
# Create Plan file
terraform plan -out aws-resource.plan
# Output the plan to readable text file
terraform show -no-color aws-resource.plan > aws-resource.txt
# Apply the resource
terraform apply

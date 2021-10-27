alias tf=terraform
tf  init  -backend-config=../../backend/backend.tfvars -backend-config="key=experience/terraform.tfstate" ../../

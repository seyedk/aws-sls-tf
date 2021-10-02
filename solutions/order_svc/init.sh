alias tf=terraform
tf  init  -backend-config=../../backend/backend.tfvars -backend-config="key=order_svc/terraform.tfstate" ../../

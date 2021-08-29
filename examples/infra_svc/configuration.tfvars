serverless = {
  backend_type        = "s3"
  level               = "level2"
  key                 = "foundation"
  global_settings_key = "foundation"
  key                 = "orders"
  tfstate_bucket_name = "seyedk-tf-accelerator-state-mgmt"




  networking = {
    vpcs = {

      db_vpc = {

        cidr            = "10.10.0.0/16"
        azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]

        # Add public_subnets and NAT Gateway to allow access to internet from Lambda
        public_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
        enable_nat_gateway = true


      }
      app_vpc = {

        cidr            = "10.11.0.0/16"
        azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
        private_subnets = ["10.11.101.0/24", "10.11.102.0/24", "10.11.103.0/24"]

        # Add public_subnets and NAT Gateway to allow access to internet from Lambda
        public_subnets     = ["10.11.1.0/24", "10.11.2.0/24", "10.11.3.0/24"]
        enable_nat_gateway = false


      }
    }
  }
}



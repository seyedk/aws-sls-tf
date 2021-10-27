provider "aws" {
  region = "us-east-1"
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
<<<<<<< HEAD
}


provider aws {
  profile = var.profile
  region  = var.region
  assume_role {
    role_arn = var.assume_role_arn
  }
}

=======
   default_tags  {
     tags = var.serverless.tags
   }
}

variable "mytag" {
  default =  "my-test-tag"
}
>>>>>>> bb8c83a2b3c2032cb7442b77632fd8bc152ecc86

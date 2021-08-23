terraform {
  required_version = ">=  0.13"
}

provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.0"
}

// merge two objects



terraform {
  backend "s3" {
    # This backend configuration is filled in automatically at test time by Terratest. If you wish to run this example
    # manually, uncomment and fill in the config below.

    bucket         = "seyedk-tf-accelerator-state-mgmt"
    key            = "db/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
    encrypt        = true
  }
}

variable "mysql_databases" {
  default = {

    test_db1 = {
      db_username = "Administrator"
      db_password = "ADSFADSFAFWERWE1341234"
    }
  }

}

module "mysql" {
  source   = "../modules/data-stores/mysql"
  #for_each = var.mysql_databases

  db_name     = "test_db2"
  db_username = "Administrator"
  db_password = "ADSFADSFAFWERWE1341234"
 
}

output "mysql" {
  value = module.mysql
}

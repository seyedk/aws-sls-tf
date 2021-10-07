# Scenario 1: Integrate with Another layer

Assuming in Infra_svc layer (with layer key `Infra`) we have created a VPC using the networking module. You may find the example solution [here.](solutions/infra_svc/configuration.tfvars)

One important parameter is `key` and its value. This is what we'll use in other layers to reference. As you see in [here.](solutions/infra_svc/configuration.tfvars) the serverless module is defineing a network with two vpcs of `db_vpc` and `app_vpc` as shown in following snippet:

```dotnetcli


    vpcs = {

      db_vpc = {

       # ... the details... of vpc
      }
      app_vpc = {

      # ... the details... of vpc

      }


    }



```

Now for the Data layer at [here](solutions/data/configuration.tfvars), where we are creating the layer with the key `data`, we are referencing the "infra" layer as shown in following snippet:

```dotnetcli
serverless = {
...
    tfstates = {
      infra = {
        tfstate = "infra/terraform.tfstate"

        region         = "us-east-1"
        dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
        encrypt        = true

      }


    }
..
}

```

As you can see, in this layer (data layer) we are going to refernce the vpc (app or db) in the infra layer for functions vpc endpoint configuration. to do that, we have used the following configuration for the function called `private_function`

```dotnetcli
private_function = {
      function_name = "my-lambda_b"
      description   = "my awesome lambda function"
      handler       = "index.lambda_handler"
      runtime       = "python3.8"
      source_path   = "src/private_function/index.py"
      tags = {
        environment = "dev"
        developer   = "seyedk"

      }
      vpc_info = {
        layer_key  = "infra"
        vpc_key    = "db_vpc"
        subnet_key = "public_subnets"
      }

    }
```

With that in mind, we need to ensure the networking is available in the remote objects and is combined with current layer's networking for each of access

**Please Note** that how we can use the networking resources created at the same layer (of data).

To see that in action, open the locals [here at](modules/serverless/locals.tf). This snippent is extracting details of `Networking` module from any of the layers in interest:

```dotnetcli
locals {

  vpc_info = {
    for f_key, f_value in local.functions :

    f_key => {
      vpc_subnet_ids = lookup(f_value, "vpc_info", null) == null ? null: local.combined_objects_vpcs[f_value.vpc_info.layer_key][f_value.vpc_info.vpc_key][f_value.vpc_info.subnet_key]
       vpc_security_group_ids = lookup(f_value, "vpc_info", null) == null ? null:local.combined_objects_vpcs[f_value.vpc_info.layer_key][f_value.vpc_info.vpc_key]["default_security_group_id"]
    }
  }
}
```

In the code snippet above, the combined_objects_vpcs, as implied by its name, combines all the remote objects and current objects together to provide easy access to the networking elements to this layer. As we have requested to look at the `infra` layer, the `local.combined_objects_vpcs[f_value.vpc_info.layer_key]` will surely contain all networking elements of `infra` when the `key=infra`. For the example configurations of data and infra, the vpc_info above will produce following data model:

```dotnetcli
 vpc_info = {
              + function1        = {}
              + private_function = {
                      + vpc_security_group_ids = "sg-0129969e695772815"
                      + vpc_subnet_ids         = [
                          + "subnet-08b6947213af4cc25",
                          + "subnet-04b7395626bf371b2",
                          + "subnet-08cade96481814ba8",
                        ]

                }
              + public_function  = {}
            }
```

in our lambda function, we'll be using local.vpc_info to get the vpc_subnet_ids required for out function:

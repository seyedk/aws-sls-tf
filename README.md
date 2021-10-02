# Architecture

The AWS-SLS-TF (the AWS Serverless with terraform) is an opiniated appraoch to implement AWS Serverless with terraform with the following high level goals:

1. Create a serverless manifest that is decoupled from its implementation detail. The manifest concept is very similar to `AWS SAM Model` where the user uses an extension of AWS CloudFormation to define the resources, and their interrelationships, in addition to input and output parameters.

2. Extracting the configuration from the implementation; the end-users only need to get trained on tailoring the configurations in a Relational manner and follow the templates (or solutions)

3. Layered Architecture where different resource owners (or implementation teams) deploy terraform and share the resources with other team members. As an example, the NOC team may create Networking resources and provide VPC endpoints, security groups, and subnet details to application development teams who will use those to create `aws lambda functions` within a VPC subnet.

The following diagram shows the above objectives:

<SPAN> </SPAN><IMG  src="https://documents.lucid.app/documents/ec4de390-a74f-45ae-9638-fd18cdb98cbf/pages/YG8x~rJwm_PR?a=4262&amp;x=1180&amp;y=153&amp;w=2942&amp;h=1477&amp;store=1&amp;accept=image%2F*&amp;auth=LCA%20c9d651fcda6bfc490b7d62a5dde04a69321d22c8-ts%3D1630560969"  />

4)Manging the layers by using Terraform State management features such as remote states, where the resources on each layer in the architecture is available to other layers in a mixture shown below:

<SPAN> </SPAN><IMG  src="https://documents.lucid.app/documents/ec4de390-a74f-45ae-9638-fd18cdb98cbf/pages/H1txgW5Ht9b2?a=4262&amp;x=-131&amp;y=83&amp;w=2882&amp;h=814&amp;store=1&amp;accept=image%2F*&amp;auth=LCA%20492dd28ba8a2f8016e1ab285548b04f2154b2e41-ts%3D1630560969" />

5)This is not meant for Serverless only, but we begin with a simple concept like serverless to build and warm up our team; later we'll evolve to cover more advanced scenarios.

## Terraform State management Example

This repo is meant to showcase using terraform states in creating layered archtiecture in AWS.

The lines 36 to 40 in [this mocule](modules/services/hello-world-app/main.tf) shows how the applicaiton layer has been implemented:

The Data Layer state is ingested into service layer. Instead

## Getting Started

In order to use the serverless accelerator, you need the folllowing prerquisites:

## Prerequisites

1. Terraform version ~>0.14
1. AWS CLI (> V2.00)
1. aws-azure-login (npm)

## Running examples

1. Change directory to `solutions` and create your serverless solution layer
1. create the serverless manifest configuration file (.tfvars)

### login

first you need to login to your aws account with an IAM user:

If you have single sign on enabled with an Identity provider, use the command line options to loign to AWS. For Azure AD, you can use `aws-azure-login` NPM Module as shown below. Use a named profile when applicable:

```bash
aws-azure-login --profile <Your Profile name>
```

### init

It's very important to pay special care when using the key. This key is will be referenced as a layer name.

```bash
tf init  -backend-config=backend/backend.tfvars -backend-config="key=<keyname>/terraform.tfstate"
```

### plan/Apply

When using the plan, you should specify the location of the serverless module:

```bash
tf plan|apply -var-file=configuration.tfvars <path to the serverless>
```

For this quick start, the location is at `../../` as shown below:

```bash
tf plan|apply -var-file=configuration.tfvars ../../
```

## Build and Test

TODO: Describe and show how to build your code and run the tests.

## Contribute

The next few sections will provide steps how to integrate one layer with other layers

### Scenario 1: Integrate with Another layer

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


Now for the Data layer at [here](solutions/data/configuration.tfvars), where we are creating the layer with the key `data`, we are referencing the "infra_svc" layer as shown in following snippet: 

```dotnetcli

    tfstates = {
      infra = {
        tfstate = "infra/terraform.tfstate"
    
        region         = "us-east-1"
        dynamodb_table = "seyedk-tf-accelerator-state-mgmt"
        encrypt        = true
    
      }
    
    
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


To see that in action, open the locals [here at](modules/serverless/locals.tf). This snippent is extracting  details of `Networking` module from any of the layers in interest:

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
                  + infra = {
                      + vpc_security_group_ids = "sg-0129969e695772815"
                      + vpc_subnet_ids         = [
                          + "subnet-08b6947213af4cc25",
                          + "subnet-04b7395626bf371b2",
                          + "subnet-08cade96481814ba8",
                        ]
                    }
                }
              + public_function  = {}
            }
```

in our lambda function, we'll be using local.vpc_info to get the vpc_subnet_ids required for out function:   


# Architecture

The AWS-SLS-TF (the AWS Serverless with terraform) is an opiniated appraoch to implement AWS Serverless with terraform with the following high level goals:

1. Create a serverless manifest that is decoupled from its implementation detail. The manifest concept is very similar to `AWS SAM Model` where the user uses an extension of AWS CloudFormation to define the resources, and their interrelationships, in addition to input and output parameters.

2. Extracting the configuration from the implementation; the end-users only need to get trained on tailoring the configurations in a Relational manner and follow the templates (or solutions)

3. Layered Architecture where different resource owners (or implementation teams) deploy terraform and share the resources with other team members. As an example, the NOC team may create Networking resources and provide VPC endpoints, security groups, and subnet details to application development teams who will use those to create `aws lambda functions` within a VPC subnet.

The following diagram shows the above objectives:  

![](docs/img/terraform%20architecture%20bg-white.png)

4)Manging the layers by using Terraform State management features such as remote states, where the resources on each layer in the architecture is available to other layers in a mixture shown below:

![](docs/img/terraform%20architecture%20-%20State%20mgmt%20conceptual.png)

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

## Integrate with Another layer

### 1 - [scenario 1 - integrate with VPC](docs/integrate-lambda-with-vpc.md)

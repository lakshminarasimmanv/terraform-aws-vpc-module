# terraform-aws-vpc-module

This Terraform module creates a complete AWS VPC with all the necessary resources, including subnets, route tables, security groups, and an Internet gateway.

## Usage

To use this module, simply add the following line to your Terraform configuration:

module "vpc" {
  source = "github.com/lakshminarasimmanv/terraform-aws-vpc-module"
}

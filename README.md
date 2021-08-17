# terraform-aws-ec2-nat
Terraform EC2 NAT Host Module

[AWS Doc about VPC NAT Instance](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#NATInstance)

## Usage

```hcl
module "nat_instance" {
    source    = "hazelops/ec2-nat/aws"
    version   = "~> 1.0"

    enabled                 = var.nat_gateway_enabled ? false : true

    env                     = var.env
    vpc_id                  = module.vpc.vpc_id
    allowed_cidr_blocks     = [module.vpc.vpc_cidr_block]
    public_subnets          = module.vpc.public_subnets
    private_route_table_id  = module.vpc.private_route_table_ids[0]
    ec2_key_pair_name       = local.key_name
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

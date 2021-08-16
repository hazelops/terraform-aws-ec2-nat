data "aws_caller_identity" "current" {}

data "aws_availability_zones" "all" {}

data "aws_ami" "nat_instance" {
  count       = var.enabled ? 1 : 0
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

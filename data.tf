data "aws_caller_identity" "current" {}

data "aws_availability_zones" "all" {}

data "template_file" "ec2_user_data" {
  template = file("${path.module}/ec2_user_data.yml.tpl")
  vars = {
    hostname         = "${var.env}-${var.name}"
  }
}

# AMI of the latest Amazon Linux 2023
data "aws_ami" "this" {
  count       = var.enabled ? 1 : 0
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = var.architecture
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-minimal*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp3"]
  }
}

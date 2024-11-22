# EC2
resource "aws_instance" "this" {
  count                  = var.enabled ? 1 : 0
  ami                    = join("", data.aws_ami.this.*.id)
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[0]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.this[0].id]

  source_dest_check           = false
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
  user_data = base64encode(data.template_file.ec2_user_data.rendered)

  tags = {
    Terraform = "true"
    Env       = var.env
    Name      = "${var.env}-${var.name}"
  }
}

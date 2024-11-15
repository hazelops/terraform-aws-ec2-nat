# Security Groups
resource "aws_security_group" "this" {
  count       = var.enabled ? 1 : 0
  name        = "${var.env}-nat-instance"
  description = "Security Group for NAT EC2 Instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow ingress traffic from the VPC CIDR block"
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all egress traffic"
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform = "true"
    Env       = var.env
    Name      = "${var.env}-nat-instance"
  }
}

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

  tags = {
    Terraform = "true"
    Env       = var.env
    Name      = "${var.env}-nat-instance"
  }

}

resource "aws_eip" "this" {
  count = var.enabled ? 1 : 0
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "${var.env}-nat-instance"
  }

  depends_on = [aws_instance.this]
}

resource "aws_eip_association" "nat_instance" {
  count         = var.enabled ? 1 : 0
  instance_id   = element(aws_instance.this.*.id, count.index)
  allocation_id = aws_eip.this[count.index].id

  depends_on = [aws_eip.this]
}

resource "aws_route" "this" {
  count = var.enabled ? 1 : 0
  route_table_id = var.private_route_table_id
  network_interface_id = element(aws_instance.this.*.primary_network_interface_id, count.index)
  destination_cidr_block = "0.0.0.0/0"
}

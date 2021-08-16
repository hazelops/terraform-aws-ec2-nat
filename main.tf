# Security Groups
resource "aws_security_group" "nat_instance" {
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
resource "aws_instance" "nat_instance" {
  count                  = var.enabled ? 1 : 0
  ami                    = join("", data.aws_ami.nat_instance.*.id)
  instance_type          = var.instance_type
  subnet_id              = var.public_subnets[0]
  key_name               = var.ec2_key_pair_name
  vpc_security_group_ids = [aws_security_group.nat_instance.*.id]

  source_dest_check = false
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

resource "aws_eip" "nat_instance" {
  count = var.enabled ? 1 : 0
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "${var.env}-nat-instance"
  }

  depends_on = [aws_instance.nat_instance]
}

resource "aws_eip_association" "nat_instance" {
  count         = var.enabled ? 1 : 0
  instance_id   = element(aws_instance.nat_instance.*.id, count.index)
  allocation_id = aws_eip.nat_instance[count.index].id

  depends_on    = [aws_eip.nat_instance]
}

resource "aws_route" "nat_instance" {
  count                  = var.enabled ? 1 : 0
  route_table_id         = var.private_route_table_id
  instance_id            = element(aws_instance.nat_instance.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
}

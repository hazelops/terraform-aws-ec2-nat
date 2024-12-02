# Security Groups
resource "aws_security_group" "this" {
  count       = var.enabled ? 1 : 0
  name        = "${var.env}-${var.name}"
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

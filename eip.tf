resource "aws_eip" "this" {
  count = var.enabled ? 1 : 0
  domain = "vpc"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Name" = "${var.env}-${var.name}"
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

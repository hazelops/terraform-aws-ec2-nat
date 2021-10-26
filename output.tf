output "instance_id" {
  value = element(aws_instance.this.*.id, 0)
}

output "security_group" {
  value = element(aws_security_group.this.*.id, 0)
}

output "public_ip" {
  value = aws_eip.this.public_ip
}

output "private_ip" {
  value = aws_eip.this.private_ip
}

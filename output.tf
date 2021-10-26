output "instance_id" {
  value = element(aws_instance.this.*.id, 0)
}

output "security_group" {
  value = element(aws_security_group.this.*.id, 0)
}

output "public_ip" {
  value = element(aws_eip.this.*.public_ip, 0)
}

output "private_ip" {
  value = element(aws_eip.this.*.private_ip, 0)
}

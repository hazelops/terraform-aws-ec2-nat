output "nat_instance_id" {
  value = element(aws_instance.nat_instance.*.id, 0)
}

output "nat_security_group" {
  value = element(aws_security_group.nat_instance.*.id, 0)
}

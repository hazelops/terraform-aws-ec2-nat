variable "env" {}
variable "vpc_id" {}
variable "private_route_table_id" {}
variable "public_subnets" {}
variable "ec2_key_pair_name" {}

variable "instance_type" {
  default = "t3.nano"
}

variable "enabled" {
  type        = bool
  default     = false
  description = "Gives ability to enable or disable Creation of NAT EC2"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of network subnets that are allowed"
  default = [
    "0.0.0.0/0"
  ]
}

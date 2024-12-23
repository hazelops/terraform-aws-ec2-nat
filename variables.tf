variable "env" {}
variable "vpc_id" {}
variable "private_route_table_id" {}
variable "public_subnets" {}
variable "ec2_key_pair_name" {}

variable "name" {
  description = "NAT instance name"
  type = string
  default = "nat-instance"
}

variable "instance_type" {
  description = "NAT instance type"
  type = string
  default = "t4g.nano"
}

variable "architecture" {
  description = "NAT instance architecture"
  type        = list(string)
  default     = ["arm64"]
}

variable "enabled" {
  description = "Gives ability to enable or disable creation of NAT EC2"
  type        = bool
  default     = false
}

variable "eip_enabled" {
  description = "Gives ability to enable or disable creation of Elastic IP"
  type = bool
  default = false
}

variable "allowed_cidr_blocks" {
  description = "List of network subnets that are allowed"
  type        = list(string)
  default = [
    "0.0.0.0/0"
  ]
}

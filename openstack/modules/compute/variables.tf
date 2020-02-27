variable "project_name" {}

variable "az_list" {
  type = list(string)
}

variable "az_list_node" {
  type = list(string)
}

variable "number_of_instances" {}

variable "instance_root_volume_size_in_gb" {}

variable "public_key_path" {}

variable "image" {}

variable "ssh_user" {}

variable "flavor" {}

variable "network_name" {}

variable "network_id" {
  default = ""
}

variable "instance_fips" {
  type = list
}

variable "instance_allowed_remote_ips" {
  type = list
}

variable "instance_allowed_egress_ips" {
  type = list
}

variable "wait_for_floatingip" {}

variable "instance_allowed_ports" {
  type = list
}

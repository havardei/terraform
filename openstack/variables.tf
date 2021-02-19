variable "project_name" {
  default = "example"
}

variable "az_list" {
  description = "List of Availability Zones to use for masters in your OpenStack cluster"
  type        = list(string)
  default     = ["nova"]
}

variable "az_list_node" {
  description = "List of Availability Zones to use for nodes in your OpenStack cluster"
  type        = list(string)
  default     = ["nova"]
}

variable "number_of_instances" {
  default = 2
}

variable "instance_root_volume_size_in_gb" {
  default = 0
}

variable "public_key_path" {
  description = "The path of the ssh pub key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "image" {
  description = "the image to use"
  default     = ""
}

variable "ssh_user" {
  description = "used to fill out tags for ansible inventory"
  default     = "ubuntu"
}

variable "flavor" {
  description = "Use 'openstack flavor list' command to see what your OpenStack instance uses for IDs"
  default     = 3
}

variable "network_name" {
  description = "name of the internal network to use"
  default     = "internal"
}

variable "use_neutron" {
  description = "Use neutron"
  default     = 1
}

variable "subnet_cidr" {
  description = "Subnet CIDR block."
  type        = string
  default     = "10.0.0.0/24"
}

variable "floatingip_pool" {
  description = "name of the floating ip pool to use"
  default     = "external"
}

variable "wait_for_floatingip" {
  description = "Terraform will poll the instance until the floating IP has been associated."
  default     = "false"
}

variable "external_net" {
  description = "uuid of the external/public network"
}

variable "instance_allowed_remote_ips" {
  description = "An array of CIDRs allowed to SSH to hosts"
  type        = list
  default     = []
}

variable "instance_allowed_egress_ips" {
  description = "An array of CIDRs allowed for egress traffic"
  type        = list
  default     = ["0.0.0.0/0"]
}

variable "instance_allowed_ports" {
  type = list

  default = []
}


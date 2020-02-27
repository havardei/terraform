provider "openstack" {
  version = "~> 1.17"
}

module "network" {
  source = "./modules/network"

  external_net       = "${var.external_net}"
  network_name       = "${var.network_name}"
  subnet_cidr        = "${var.subnet_cidr}"
  project_name       = "${var.project_name}"
  use_neutron        = "${var.use_neutron}"
}

module "ips" {
  source = "./modules/ips"

  number_of_instances         = "${var.number_of_instances}"
  floatingip_pool               = "${var.floatingip_pool}"
  external_net                  = "${var.external_net}"
  network_name                  = "${var.network_name}"
  router_id                     = "${module.network.router_id}"
}

module "compute" {
  source = "./modules/compute"
  project_name                                 = "${var.project_name}"
  az_list                                      = "${var.az_list}"
  az_list_node                                 = "${var.az_list_node}"
  number_of_instances                          = "${var.number_of_instances}"
  instance_root_volume_size_in_gb              = "${var.instance_root_volume_size_in_gb}"
  public_key_path                              = "${var.public_key_path}"
  image                                        = "${var.image}"
  ssh_user                                     = "${var.ssh_user}"
  flavor                                       = "${var.flavor}"
  network_name                                 = "${var.network_name}"
  instance_fips                                = "${module.ips.instance_fips}"
  instance_allowed_remote_ips                  = "${var.instance_allowed_remote_ips}"
  instance_allowed_egress_ips                  = "${var.instance_allowed_egress_ips}"
  instance_allowed_ports                       = "${var.instance_allowed_ports}"
  wait_for_floatingip                          = "${var.wait_for_floatingip}"

  network_id = "${module.network.router_id}"
}

output "private_subnet_id" {
  value = "${module.network.subnet_id}"
}

output "floating_network_id" {
  value = "${var.external_net}"
}

output "router_id" {
  value = "${module.network.router_id}"
}

output "instance_fips" {
  value = "${module.ips.instance_fips}"
}

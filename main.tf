
module "openstack" {
  source = "./openstack"
  project_name = ""
  public_key_path = ""
  image = ""
  flavor = ""
  network_name = "test"
  external_net = ""
  floatingip_pool = ""
  number_of_instances = 1
  instance_root_volume_size_in_gb = 80
  instance_allowed_remote_ips = [] # ssh-access from
  instance_allowed_ports = [] 
}
output "instance_ips" {
  value = "${module.openstack.instance_fips}"
}

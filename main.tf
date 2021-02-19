
module "openstack" {
  source = "./openstack"
  project_name = ""
  public_key_path = ""
  image = ""
  flavor = ""
  external_net = ""
  floatingip_pool = ""
  number_of_instances = 1
  instance_allowed_remote_ips = [] #ssh-access
}
output "instance_ips" {
  value = "${module.openstack.instance_fips}"
}

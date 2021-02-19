
module "openstack" {
  source = "./openstack"
  project_name = "test"
  public_key_path = "~/.ssh/id_rsa.pub"
  image = "Ubuntu Server 18.04 (Bionic) amd64 20200807"
  flavor = "08f9d311-fb51-49f9-9c55-6d57b7d71015"
  network_name = "test"
  external_net = "e1061b4b-9259-40e6-ba27-480037f649c8"
  floatingip_pool = "ntnu-global"
  number_of_instances = 1
  instance_root_volume_size_in_gb = 80
  instance_allowed_remote_ips = ["10.0.0.0/8","129.241.0.0/16"] #ssh-tilgang
  instance_allowed_ports = [] #porter man vil eksponere til cidr (se ./openstack/variables.tf)
}
output "instance_ips" {
  value = "${module.openstack.instance_fips}"
}

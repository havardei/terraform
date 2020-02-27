output "instance_fips" {
  value = "${openstack_networking_floatingip_v2.instance[*].address}"
}
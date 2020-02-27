resource "null_resource" "dummy_dependency" {
  triggers = {
    dependency_id = var.router_id
  }
}

resource "openstack_networking_floatingip_v2" "instance" {
  count      = var.number_of_instances
  pool       = var.floatingip_pool
  depends_on = [null_resource.dummy_dependency]
}

data "openstack_images_image_v2" "vm_image" {
  name = "${var.image}"
}

resource "openstack_compute_keypair_v2" "keypair" {
  name       = "keypair-${var.project_name}"
  public_key = chomp(file(var.public_key_path))
}


resource "openstack_networking_secgroup_v2" "instance" {
  name                 = "${var.project_name}-ssh"
  description          = "${var.project_name} - Instance"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  count             = length(var.instance_allowed_remote_ips)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  remote_ip_prefix  = var.instance_allowed_remote_ips[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance.id
}

resource "openstack_networking_secgroup_rule_v2" "egress" {
  count             = length(var.instance_allowed_egress_ips)
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = var.instance_allowed_egress_ips[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance.id
}

resource "openstack_networking_secgroup_rule_v2" "allowed_ports" {
  count             = length(var.instance_allowed_ports)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = lookup(var.instance_allowed_ports[count.index], "protocol", "tcp")
  port_range_min    = lookup(var.instance_allowed_ports[count.index], "port_range_min")
  port_range_max    = lookup(var.instance_allowed_ports[count.index], "port_range_max")
  remote_ip_prefix  = lookup(var.instance_allowed_ports[count.index], "remote_ip_prefix", "0.0.0.0/0")
  security_group_id = openstack_networking_secgroup_v2.instance.id
}

resource "openstack_compute_instance_v2" "instance" {
  name              = "${var.project_name}-instance-${count.index+1}"
  count             = var.instance_root_volume_size_in_gb == 0 ? var.number_of_instances : 0
  availability_zone = element(var.az_list, count.index)
  image_name        = var.image
  flavor_id         = var.flavor
  key_pair          = openstack_compute_keypair_v2.keypair.name

  network {
    name = var.network_name
  }

  security_groups = [openstack_networking_secgroup_v2.instance.name]

  metadata = {
    ssh_user         = var.ssh_user
    depends_on       = var.network_id
  }

#  provisioner "local-exec" {
#  }
}

resource "openstack_compute_instance_v2" "instance_custom_volume_size" {
  name              = "${var.project_name}-instance-${count.index+1}"
  count             = var.instance_root_volume_size_in_gb > 0 ? var.number_of_instances : 0
  availability_zone = element(var.az_list, count.index)
  image_name        = var.image
  flavor_id         = var.flavor
  key_pair          = openstack_compute_keypair_v2.keypair.name

  block_device {
    uuid                  = data.openstack_images_image_v2.vm_image.id
    source_type           = "image"
    volume_size           = var.instance_root_volume_size_in_gb
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = var.network_name
  }

  security_groups = [openstack_networking_secgroup_v2.instance.name]
  
  metadata = {
    ssh_user         = var.ssh_user
    depends_on       = var.network_id
  }
  
#  provisioner "local-exec" {
#  }
}

resource "openstack_compute_floatingip_associate_v2" "instance" {
  count                 = var.instance_root_volume_size_in_gb == 0 ? var.number_of_instances : 0
  instance_id           = element(openstack_compute_instance_v2.instance.*.id, count.index)
  floating_ip           = var.instance_fips[count.index]
  wait_until_associated = var.wait_for_floatingip
}

resource "openstack_compute_floatingip_associate_v2" "instance_custom_volume_size" {
  count                 = var.instance_root_volume_size_in_gb > 0 ? var.number_of_instances : 0
  instance_id           = element(openstack_compute_instance_v2.instance_custom_volume_size.*.id, count.index)
  floating_ip           = var.instance_fips[count.index]
  wait_until_associated = var.wait_for_floatingip
}

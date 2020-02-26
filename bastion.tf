# this is the SG applied to the bastian instance
resource "ibm_is_security_group" "bastion" {
  name = "${var.unique_id}-bastion-sg"
  vpc  = ibm_is_vpc.vpc.id
}

# users of the bastian. for example from on premises
resource "ibm_is_security_group_rule" "bastion_ingress_ssh_all" {
  group     = ibm_is_security_group.bastion.id
  direction = "inbound"

  remote = local.bastion_ingress_cidr

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "bastion_egress_ssh_all" {
  group     = ibm_is_security_group.bastion.id
  direction = "outbound"
  remote    = ibm_is_security_group.webserver.id

  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_instance" "bastion" {
  name    = "${var.unique_id}--bastion-vsi"
  image   = data.ibm_is_image.os.id
  profile = var.profile

  primary_network_interface {
    subnet          = ibm_is_subnet.az1_subnet[0].id
    security_groups = [ibm_is_security_group.bastion.id]
  }

  vpc            = ibm_is_vpc.vpc.id
  zone           = element(var.az_list,0)
  resource_group = data.ibm_resource_group.all_rg.id
  keys           = [data.ibm_is_ssh_key.sshkey.id]
  user_data      = file("cloud_config.yml")
//   user_data      = file("cloudinit.tf")
}

resource "ibm_is_floating_ip" "bastion" {
  name   = "${var.unique_id}-float-bastion-ip"
  target = ibm_is_instance.bastion.primary_network_interface[0].id
}

/*
# resource "ibm_is_security_group_rule" "maintenance_egress_443" {
#   group     = "${ibm_is_security_group.maintenance.id}"
#   direction = "outbound"
#   remote    = "0.0.0.0/0"
#   tcp = {
#     port_min = 443
#     port_max = 443
#   }
# }
*/

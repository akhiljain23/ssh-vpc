# this is the SG applied to the bastian instance
resource "ibm_is_security_group" "bastion" {
  name = "${var.unique_id}-bastion-sg"
  vpc  = "${ibm_is_vpc.vpc.id}"
}

# users of the bastian. for example from on premises
resource "ibm_is_security_group_rule" "bastion_ingress_ssh_all" {
  group     = "${ibm_is_security_group.bastion.id}"
  direction = "inbound"

  #remote    = "${var.remote}"

  tcp = {
    port_min = 22
    port_max = 22
  }
}

# resource "ibm_is_security_group_rule" "bastion_egress_ssh_maintenance" {
#   group     = "${ibm_is_security_group.bastion.id}"
#   direction = "outbound"
#   remote    = "${ibm_is_security_group.maintenance.id}"

#   tcp = {
#     port_min = 22
#     port_max = 22
#   }
# }

resource "ibm_is_instance" "bastion" {
  name    = "${var.unique_id}--bastion-vsi"
  image   = "${var.ibm_is_image_id}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet          = "${var.ibm_is_subnet_id}"
    security_groups = ["${ibm_is_security_group.bastion.id}"]
  }

  vpc            = "${var.ibm_is_vpc_id}"
  zone           = "${element(var.az_list, count.index)}"
  resource_group = "${var.ibm_is_resource_group_id}"
  keys           = ["${var.ibm_is_ssh_key_id}"]
}

# resource "ibm_is_floating_ip" "bastion" {
#   name   = "${var.basename}-bastion-ip"
#   target = "${ibm_is_instance.bastion.primary_network_interface.0.id}"
# }
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


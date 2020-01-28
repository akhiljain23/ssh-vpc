# this is the SG applied to the webserver instance
resource "ibm_is_security_group" "webserver" {
  name = "${var.unique_id}-webserver-sg"
  vpc  = "${ibm_is_vpc.vpc.id}"
}

# users of the bastian. for example from on premises
resource "ibm_is_security_group_rule" "webserver_ingress_ssh_all" {
  group     = "${ibm_is_security_group.webserver.id}"
  direction = "inbound"

  #remote    = "${var.remote}"

  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "webserver_egress_ssh_all" {
  group     = "${ibm_is_security_group.webserver.id}"
  direction = "outbound"
  remote    = "${ibm_is_security_group.maintenance.id}"

  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_instance" "webserver" {
  name    = "${var.unique_id}--webserver-vsi"
  image   = "${data.ibm_is_image.os.id}"
  profile = "${var.profile}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.az1_subnet.id}"
    security_groups = ["${ibm_is_security_group.webserver.id}"]
  }

  vpc            = "${ibm_is_vpc.vpc.id}"
  zone           = "${element(var.az_list, count.index)}"
  resource_group = "${data.ibm_resource_group.all_rg.id}"
  keys           = ["${data.ibm_is_ssh_key.sshkey.id}"]
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


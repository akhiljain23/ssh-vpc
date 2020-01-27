##############################################################################
# Create an  ACL for ingress/egress used by  all subnets in VPC
##############################################################################
# resource "ibm_is_network_acl" "multizone_acl" {
#   name = "${var.unique_id}-multizone-acl"
#   vpc  = "${ibm_is_vpc.vpc.id}"
#   rules = [
#     {
#       name        = "outbound1"
#       action      = "allow"
#       source      = "0.0.0.0/0"
#       destination = "0.0.0.0/0"
#       direction   = "inbound"
#       tcp {
#         port_max = 22
#         port_min = 22
#       }
#     },
#     {
#       name        = "outbound1"
#       action      = "allow"
#       source      = "0.0.0.0/0"
#       destination = "0.0.0.0/0"
#       direction   = "outbound"
#       tcp {
#         port_max = 65535
#         port_min = 1
#       }
#     },
#   ]
# }
##############################################################################


provider "ibm" {
  region = "${var.ibm_region}"

  #ibmcloud_api_key = "${var.ibmcloud_api_key}"
  generation = "${var.generation}"
}

data "ibm_resource_group" "all_rg" {
  name = "${var.resource_group_name}"
}

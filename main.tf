provider "ibm" {
  region = "${var.region}"

  #ibmcloud_api_key = "${var.ibmcloud_api_key}"
  generation       = "${var.generation}"
  ibmcloud_timeout = "${var.ibmcloud_timeout}"
}

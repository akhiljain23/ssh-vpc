resource "ibm_is_public_gateway" "test_gateway" {
    count = "3"
    name = "${var.unique_id}-public-gtw-${count.index}"
    vpc = "${data.ibm_is_vpc.vpc.id}"
    zone = "us-south-${count.index + 1}"
    //User can configure timeouts
    timeouts {
        create = "90m"
    }
} 
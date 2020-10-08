# Date source retrieves the informaton from remote cloud.
data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_availability_domain" "ad1" {
  compartment_id = var.tenancy_ocid
  ad_number      = 2
}

resource "oci_core_vcn" "ai_vcn" {
  cidr_block     = var.newcidrblock
  dns_label      = var.newdnslabel
  compartment_id = var.compartment_id
  display_name   = var.newvcndisplayname
}

resource "oci_core_internet_gateway" "ai_internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = var.newinternetgatewaydisplayname
  vcn_id         = oci_core_vcn.ai_vcn.id
}


resource "oci_core_subnet" "example_subnet" {
  availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block          = "10.10.20.0/24"
  display_name        = "ai subment public"
  dns_label           = "public subnet dns label"

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ai_vcn.id
}

resource "oci_core_subnet" "example_subnet1" {
  availability_domain = data.oci_identity_availability_domain.ad1.name
  cidr_block          = "10.10.21.0/24"
  display_name        = "ai subnet private"
  dns_label           = "private subnet dns label"

  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.ai_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.ai_vcn.default_route_table_id
  display_name               = "defaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ai_internet_gateway.id
  }
}

resource "oci_core_route_table_attachment" "example_route_table_attachment" {
  subnet_id      = oci_core_subnet.example_subnet.id
  route_table_id = oci_core_default_route_table.default_route_table.id
}

resource "oci_core_route_table_attachment" "example_route_table_attachment1" {
  subnet_id      = oci_core_subnet.example_subnet1.id
  route_table_id = oci_core_default_route_table.default_route_table.id
}

resource "oci_core_default_security_list" "default_security_list" {
  manage_default_resource_id = oci_core_vcn.ai_vcn.default_security_list_id
  display_name               = "defaultSecurityList"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "6"
  }

  ingress_security_rules {
    protocol  = "6"        
    source    = "0.0.0.0/0"
    stateless = false

    tcp_options {
      min = 22
      max = 22
    }
  }

}

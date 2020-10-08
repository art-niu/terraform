# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Output the result
output "show-ads" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

resource "oci_identity_compartment" "ai_oci_compartment" {
  name = "compartment-rain"
  description = "Compartment for project Rain"
}


output "compartments" {
  value = oci_identity_compartment.ai_oci_compartment.compartment_id
}

resource "oci_identity_user" "ai_oci_user" {
  name = var.newuser
  description = var.newuserdescriptoin
  compartment_id = oci_identity_compartment.ai_oci_compartment.compartment_id
}

output "oci_user" {
  value = oci_identity_user.ai_oci_user.name
}

resource "oci_identity_ui_password" "ai_oci_password" {
  user_id = oci_identity_user.ai_oci_user.id
}

output "user_password" {
  sensitive = false
  value = oci_identity_ui_password.ai_oci_password.password
}

resource "oci_identity_group" "ai_oci_group" {
  name = var.newgroup
  description = var.newgroupdescription
}

resource "oci_identity_user_group_membership" "ai_user_group_binding" {
    group_id = oci_identity_group.ai_oci_group.id
    user_id = oci_identity_user.ai_oci_user.id
}


data "oci_identity_groups" "ai_oci_groups" {
    compartment_id = oci_identity_compartment.ai_oci_compartment.compartment_id

    filter {
      name = "name"
      values = [var.newgroup]
    }
}

output "oci_groups" {
  value = data.oci_identity_groups.ai_oci_groups.groups.0.name
}


resource "oci_identity_policy" "ai_oci_policy" {
    compartment_id = oci_identity_compartment.ai_oci_compartment.compartment_id
    description = var.newpolicydescription
    name = var.newpolicy
    statements = [
    "Allow group ${oci_identity_group.ai_oci_group.name} to read instances in compartment ${oci_identity_compartment.ai_oci_compartment.name}",
    "Allow group ${oci_identity_group.ai_oci_group.name} to inspect instances in compartment ${oci_identity_compartment.ai_oci_compartment.name}"
    ]
}

output "policy" {
  value = oci_identity_policy.ai_oci_policy.id
}

output "policy_statements"{
  value = oci_identity_policy.ai_oci_policy.statements
}
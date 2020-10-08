variable "tenancy_ocid" {
    default = "ocid1.tenancy.oc1..aaaaaaaa4oap7i7d6ayyxtltnuavcij6ppoze3tier6n2qeh7xzl6lpc"
}

variable "user_ocid" {
    default = "ocid1.user.oc1..aaaaaaaancvk6t2zumcs5rssbifrqksbrnhty5ihlb2vbrmdnefhnxqa4"
}

variable "fingerprint" {

    default = "d0:b6:fc:ae:c6:fa:94:ea:ee:19:93:97:65:f2:82:95"
}

 variable "private_key_path" {
     default = "/Users/fei/.oci/oci_api_key.pem"
 }

variable "region" {
    default = "ca-toronto-1"
}

variable "ip-set-list" {
    type    = list(striing)
    default = [
        "74.13.163.6/32",
        "74.13.163.8/32"
    ]
}

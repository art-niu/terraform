
# Create Web ACL to secure Tableau Access

resource "aws_waf_ipset" "fei-egress-ipset" {
  name = "ESIEgressIPs"

  for_each = var.fei-egress-ip-set-list
  ip_set_descriptors {
    type  = "IPV4"
    value = each.value
  }
}

# Create IP set for site 24x7
/* resource "aws_waf_ipset" "site-24-7-ipset" {
  name = "site24x7'"

  ip_set_descriptors {
    type  = "IPV4"
    value = "192.0.7.0/24"
  }
}
 */
# Create WAF rule
resource "aws_waf_rule" "wafrule" {
  depends_on  = [aws_waf_ipset.fei-egress-ipset]
  name        = "tfWAFRule"
  metric_name = "tfWAFRule"

  predicates {
    data_id = aws_waf_ipset.ipset.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_waf_web_acl" "waf_acl" {
  depends_on = [
    aws_waf_ipset.ipset,
    aws_waf_rule.wafrule,
  ]
  name        = "ESIUserAccess"
  metric_name = "ESIUserAccess"

  default_action {
    type = "ALLOW"
  }

  rules {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_waf_rule.wafrule.id
    type     = "REGULAR"
  }
}

/* output "waf" {
  value = ["${local.wafs}"]
} */

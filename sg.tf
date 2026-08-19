resource "aws_vpc_security_group_vpc_association" "current" {
  for_each = var.security_group.vpc_associations

  security_group_id = aws_security_group.current.id
  vpc_id            = each.value
}

resource "aws_security_group" "current" {
  name                   = var.security_group.name
  name_prefix            = var.security_group.name_prefix
  description            = var.security_group.description
  vpc_id                 = var.security_group.vpc_id
  revoke_rules_on_delete = var.security_group.revoke_rules_on_delete
  tags                   = var.security_group.tags
}

resource "aws_vpc_security_group_ingress_rule" "current" {
  for_each = var.security_group.ingress

  security_group_id            = aws_security_group.current.id
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_egress_rule" "current" {
  for_each = var.security_group.egress

  security_group_id            = aws_security_group.current.id
  description                  = each.value.description
  ip_protocol                  = each.value.ip_protocol
  from_port                    = each.value.from_port
  to_port                      = each.value.to_port
  cidr_ipv4                    = each.value.cidr_ipv4
  cidr_ipv6                    = each.value.cidr_ipv6
  prefix_list_id               = each.value.prefix_list_id
  referenced_security_group_id = each.value.referenced_security_group_id
}

resource "aws_vpc_security_group_rules_exclusive" "current" {
  security_group_id = aws_security_group.current.id

  ingress_rule_ids = [
    for rule in values(aws_vpc_security_group_ingress_rule.current) :
    rule.id
  ]

  egress_rule_ids = [
    for rule in values(aws_vpc_security_group_egress_rule.current) :
    rule.id
  ]
}

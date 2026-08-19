output "resources" {
  description = "Managed resources."

  value = {
    aws_security_group                     = aws_security_group.current,
    aws_vpc_security_group_egress_rule     = aws_vpc_security_group_egress_rule.current,
    aws_vpc_security_group_ingress_rule    = aws_vpc_security_group_ingress_rule.current,
    aws_vpc_security_group_rules_exclusive = aws_vpc_security_group_rules_exclusive.current,
    aws_vpc_security_group_vpc_association = aws_vpc_security_group_vpc_association.current,
  }
}

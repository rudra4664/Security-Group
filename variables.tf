variable "security_group" {
  description = "Configuration for the AWS Security Group."

  type = object({
    name                   = optional(string, null)
    name_prefix            = optional(string, null)
    description            = optional(string, null)
    vpc_id                 = string
    vpc_associations       = optional(set(string), [])
    revoke_rules_on_delete = optional(bool, false)
    tags                   = map(string)

    ingress = optional(map(object({
      description                  = optional(string, null)
      ip_protocol                  = string
      from_port                    = optional(number, null)
      to_port                      = optional(number, null)
      cidr_ipv4                    = optional(string, null)
      cidr_ipv6                    = optional(string, null)
      prefix_list_id               = optional(string, null)
      referenced_security_group_id = optional(string, null)
    })), {})

    egress = optional(map(object({
      description                  = optional(string, null)
      ip_protocol                  = string
      from_port                    = optional(number, null)
      to_port                      = optional(number, null)
      cidr_ipv4                    = optional(string, null)
      cidr_ipv6                    = optional(string, null)
      prefix_list_id               = optional(string, null)
      referenced_security_group_id = optional(string, null)
    })), {})
  })

  validation {
    condition = (
      contains(keys(var.security_group.tags), "appid") &&
      length(trimspace(var.security_group.tags["appid"])) > 0
    )

    error_message = "The tags map must include a non-empty 'appid' value."
  }

  validation {
    condition = alltrue([
      for rule in values(var.security_group.ingress) :
      contains(
        ["-1", "icmp", "icmpv6", "tcp", "udp"],
        lower(rule.ip_protocol)
      )
    ])

    error_message = "Ingress rule ip_protocol must be one of '-1', 'icmp', 'icmpv6', 'tcp', 'udp'."
  }

  validation {
    condition = alltrue([
      for rule in values(var.security_group.egress) :
      contains(
        ["-1", "icmp", "icmpv6", "tcp", "udp"],
        lower(rule.ip_protocol)
      )
    ])

    error_message = "Egress rule ip_protocol must be one of '-1', 'icmp', 'icmpv6', 'tcp', 'udp'."
  }

  validation {
    condition = alltrue([
      for rule in concat(
        values(var.security_group.ingress),
        values(var.security_group.egress)
      ) :
      lower(rule.ip_protocol) == "-1"
      ? (
        rule.from_port == -1 &&
        rule.to_port == -1
      )
      : (
        rule.from_port >= 0 &&
        rule.from_port <= 65535 &&
        rule.to_port >= rule.from_port &&
        rule.to_port <= 65535
      )
    ])

    error_message = "For ip_protocol='-1', both from_port and to_port must be -1. Otherwise ports must be between 0 and 65535, and to_port must be greater than or equal to from_port."
  }

  validation {
    condition = alltrue([
      for rule in concat(
        values(var.security_group.ingress),
        values(var.security_group.egress)
      ) :
      rule.cidr_ipv4 == null ||
      can(cidrhost(rule.cidr_ipv4, 0))
    ])

    error_message = "Invalid IPv4 CIDR block."
  }

  validation {
    condition = alltrue([
      for rule in concat(
        values(var.security_group.ingress),
        values(var.security_group.egress)
      ) :
      rule.cidr_ipv6 == null ||
      can(cidrhost(rule.cidr_ipv6, 0))
    ])

    error_message = "Invalid IPv6 CIDR block."
  }

  validation {
    condition = alltrue([
      for rule in concat(
        values(var.security_group.ingress),
        values(var.security_group.egress)
      ) :
      length(compact([
        rule.cidr_ipv4,
        rule.cidr_ipv6,
        rule.prefix_list_id,
        rule.referenced_security_group_id,
      ])) > 0
    ])

    error_message = "Each rule must specify at least one of cidr_ipv4, cidr_ipv6, prefix_list_id, or referenced_security_group_id."
  }
}

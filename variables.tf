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
      tags                         = optional(map(string), {})
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
      tags                         = optional(map(string), {})
    })), {})
  })
}

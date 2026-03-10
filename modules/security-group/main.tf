resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_security_group_rule" "ingress" {
  for_each = { for rule in var.ingress_rules : "${rule.protocol}-${rule.from_port}-${rule.to_port}-${rule.description}" => rule }

  security_group_id = aws_security_group.this.id
  type              = "ingress"
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol

  cidr_blocks              = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  source_security_group_id = each.value.source_security_group_id
}

resource "aws_security_group_rule" "egress" {
  for_each = { for rule in var.egress_rules : "${rule.protocol}-${rule.from_port}-${rule.to_port}-${rule.description}" => rule }

  security_group_id = aws_security_group.this.id
  type              = "egress"
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol

  cidr_blocks = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks : null
  # NOTE: The AWS provider uses source_security_group_id for both ingress and egress rules
  source_security_group_id = each.value.destination_security_group_id
}

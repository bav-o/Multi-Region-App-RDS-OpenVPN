resource "aws_route53_zone" "this" {
  name = var.domain_name

  dynamic "vpc" {
    for_each = var.is_private ? var.vpc_associations : []

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}

resource "aws_route53_health_check" "health_check" {
  for_each = { for hc in var.health_checks : hc.name => hc }

  ip_address        = each.value.ip_address
  port              = each.value.port
  type              = each.value.type
  resource_path     = each.value.resource_path
  failure_threshold = each.value.failure_threshold
  request_interval  = each.value.request_interval

  tags = merge(var.tags, {
    Name = each.key
  })
}

resource "aws_route53_record" "record" {
  for_each = { for record in var.records : "${record.name}-${record.type}${record.set_identifier != null ? "-${record.set_identifier}" : ""}" => record }

  zone_id         = aws_route53_zone.this.zone_id
  name            = "${each.value.name}.${var.domain_name}"
  type            = each.value.type
  ttl             = each.value.alias == null ? each.value.ttl : null
  records         = length(each.value.values) > 0 ? each.value.values : null
  set_identifier  = each.value.set_identifier
  health_check_id = each.value.health_check_id

  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  dynamic "failover_routing_policy" {
    for_each = each.value.failover_routing_policy != null ? [each.value.failover_routing_policy] : []
    content {
      type = failover_routing_policy.value
    }
  }
}

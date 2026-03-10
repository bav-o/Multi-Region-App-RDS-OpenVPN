resource "aws_vpc_peering_connection" "this" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  auto_accept = false

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_vpc_peering_connection_accepter" "this" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
  auto_accept               = true

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_vpc_peering_connection_options" "requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.this]
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider                  = aws.peer
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  depends_on = [aws_vpc_peering_connection_accepter.this]
}

resource "aws_route" "requester" {
  for_each = toset(var.requester_route_table_ids)

  route_table_id            = each.value
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "accepter" {
  provider = aws.peer
  for_each = toset(var.accepter_route_table_ids)

  route_table_id            = each.value
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

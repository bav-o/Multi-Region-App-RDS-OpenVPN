resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 30
  }

  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = var.name
  })
}

resource "aws_eip_association" "this" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this.id
}

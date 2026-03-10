provider "aws" {
  region = "eu-west-1"
}

variables {
  domain_name = "test.example.com"

  records = [
    {
      name   = "app"
      type   = "A"
      values = ["10.0.1.10"]
    },
    {
      name   = "api"
      type   = "CNAME"
      values = ["app.test.example.com"]
    }
  ]
}

run "creates_hosted_zone" {
  command = plan

  assert {
    condition     = aws_route53_zone.this.name == "test.example.com"
    error_message = "Zone name does not match."
  }
}

run "creates_records" {
  command = plan

  assert {
    condition     = length(aws_route53_record.this) == 2
    error_message = "Expected 2 DNS records."
  }
}

resource "aws_route53_zone" "main" {
  name = "considerthesource.io"
}

resource "aws_route53_record" "AWS-Basic-infra-ns" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "AWS-Basic-infra-ns.considerthesource.io"
  type    = "NS"
  ttl     = "300"
  records = aws_route53_zone.main.name_servers
}


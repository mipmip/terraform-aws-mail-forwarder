data "aws_route53_zone" "default" {
  name = var.domain
}

#resource "aws_route53_record" "default" {
#  zone_id = data.aws_route53_zone.default.zone_id
#  name    = "_amazonses.${aws_ses_domain_identity.default.id}"
#  type    = "TXT"
#  ttl     = "600"
#  records = [aws_ses_domain_identity.default.verification_token]
#}

# Add Route53 MX record
resource "aws_route53_record" "mx" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = data.aws_ses_domain_identity.default.id
  type    = "MX"
  ttl     = "600"
  records = ["10 inbound-smtp.${var.region}.amazonaws.com"]
  # Change to the region in which `aws_ses_domain_identity.default` is created
}

data "aws_ses_domain_identity" "default" {
  domain = var.domain
}
#
#resource "aws_ses_domain_identity_verification" "default" {
#  domain = aws_ses_domain_identity.default.id
#
#  depends_on = [aws_route53_record.default]
#}

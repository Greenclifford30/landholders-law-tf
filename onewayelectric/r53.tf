# We assume there's a data or resource block referencing your zone
# If you already have the zone, you might do:
data "aws_route53_zone" "selected" {
  name         = "onewayelectricchi.com"
  private_zone = false
}

# resource "aws_route53_record" "ses_verification_record" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = "_amazonses.${var.ses_domain_name}" 
#   type    = "TXT"
#   ttl     = 300
#   records = [aws_ses_domain_identity.landholderslaw_domain.verification_token]
# }

# # DKIM creates 3 CNAMEs for each private key
# resource "aws_route53_record" "ses_dkim_record" {
#   count   = 3
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = "${element(aws_ses_domain_dkim.landholderslaw_domain_dkim.dkim_tokens, count.index)}._domainkey.${var.ses_domain_name}"
#   type    = "CNAME"
#   ttl     = 300
#   records = ["${element(aws_ses_domain_dkim.landholderslaw_domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
# }

# # If you're using mail-from, you'll need an MX record for the mail-from domain:
# resource "aws_route53_record" "ses_mailfrom_mx" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = "bounces.${var.ses_domain_name}"
#   type    = "MX"
#   ttl     = 300
#   records = ["10 feedback-smtp.us-east-1.amazonses.com"] # region-specific
# }

resource "aws_route53_record" "google_site_verification" {
  zone_id = data.aws_route53_zone.selected.zone_id

  # If you're verifying at the root (apex) of the domain, set 'name' to the domain_name
  # If verifying a subdomain, set to subdomain.domain_name
  name = "onewayelectricchi.com"

  type = "TXT"
  ttl  = 300

  # Important: For TXT records in Terraform, wrap the text in additional quotes
  # e.g. records = ["\"google-site-verification=xxxx\""]
  records = ["${var.google_verification_value}"]
}
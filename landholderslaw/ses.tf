###########################
# 1) Domain Identity
###########################
resource "aws_ses_domain_identity" "landholderslaw_domain" {
  domain = var.ses_domain_name
}

# The next resource automatically verifies the domain identity 
# once the DNS record is in place. If DNS is not in Route53, 
# you can omit this and verify manually via the console.
resource "aws_ses_domain_identity_verification" "landholderslaw_domain_verify" {
  domain = aws_ses_domain_identity.landholderslaw_domain.domain
  depends_on = [
    aws_route53_record.ses_verification_record
  ]
}

###########################
# 2) DKIM Setup
###########################
resource "aws_ses_domain_dkim" "landholderslaw_domain_dkim" {
  domain = aws_ses_domain_identity.landholderslaw_domain.domain
}

###########################
# 3) (Optional) Mail-From
###########################
resource "aws_ses_domain_mail_from" "landholderslaw_domain_mailfrom" {
  domain          = aws_ses_domain_identity.landholderslaw_domain.domain
  mail_from_domain = "bounces.${var.ses_domain_name}"
  behavior_on_mx_failure = "UseDefaultValue"
}

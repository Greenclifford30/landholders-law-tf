module landholderslaw {
    source = "./landholderslaw"
    google_verification_value = var.google_verification_value
}

module "onewayelectric" {
  source = "./onewayelectric"
  google_verification_value = ""
}
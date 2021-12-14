locals {
  prefix = "sap-labs"

  lambda_zip_path    = "${path.module}/lambda.zip"
  lambda_bundle_path = "${path.root}/lambda_scripts"
}
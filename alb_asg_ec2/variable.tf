locals {
  prefix = "sap-labs-web"
  az_a   = "ap-northeast-1a"
  az_c   = "ap-northeast-1c"

  vpc_cidr_block = "10.0.0.0/16"

  public_subnet_1_cidr  = "10.0.1.0/24"
  public_subnet_2_cidr  = "10.0.2.0/24"
  private_subnet_1_cidr = "10.0.3.0/24"
  private_subnet_2_cidr = "10.0.4.0/24"

  instance_ami      = "ami-02892a4ea9bfa2192"
  instance_key_name = "sap_lab"

  error_message_json = jsonencode({ "moreInfo" : {
    "code" : "10000",
    "userMessage" : "Bad request",
  } })
}
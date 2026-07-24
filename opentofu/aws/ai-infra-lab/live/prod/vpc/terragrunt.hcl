terraform {
  source = "../../../modules/vpc"
}

inputs = {
  vpc_cidr = "10.1.0.0/16"
}

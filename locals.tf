data "aws_availability_zones" "available" {}

locals {
  name     = "eks"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Name                                   = local.name
    "kubernetes.io/cluster/vpc-serverless" = "shared"
  }

}

# default VPC
data "aws_vpc" "pospisilv_vpc" {
  default = true
}

data "aws_subnets" "albsubnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pospisilv_vpc.id]
  }
}

data "aws_subnets" "ecssubnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pospisilv_vpc.id]
  }
}

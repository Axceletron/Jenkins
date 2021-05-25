resource "aws_vpc" "my_vpc" {
  cidr_block = var.ipblock
  tags = {
    for tag in var.vpc_tag:
      tag.name => tag.val
  }
}


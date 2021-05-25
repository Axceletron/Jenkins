resource "aws_subnet" "my_subnet" {
  vpc_id            = var.vpc_id
  cidr_block        = var.subnet_ipblock
  availability_zone = var.av_zns

  tags = {
    for tag in var.subnet_tag:
      tag.name => tag.val
  }
} 
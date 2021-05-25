
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpcid

  tags = {
    for tag in var.igw_tag:
      tag.name => tag.val
  }
}


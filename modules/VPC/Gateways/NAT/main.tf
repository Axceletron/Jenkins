resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.sub_id

  tags = {
    for tag in var.nat_tag:
      tag.name => tag.val
  }
}

resource "aws_eip" "nat" {
  vpc      = true
  tags = {
    for tag in var.nat_ip_tag:
      tag.name => tag.val
  }
}
resource "aws_route_table" "rt" {
  vpc_id = var.vpcid

  tags = {
    for tag in var.rt_tag:
      tag.name => tag.val
  }
}



module "Routecr" {
  source = "./routesdef"
  for_each = {for x in var.rts: x.gwtype => x}
  rt_id = aws_route_table.rt.id
  rt_cidr = each.value["dcidr"]
  gwid = each.value["gwid"]
  gwtype = each.key
}


resource "aws_route_table_association" "a" {
  for_each = toset(var.sub_id)
  subnet_id      = each.key
  route_table_id = aws_route_table.rt.id
}

output "rt" {
  value = var.sub_id
}
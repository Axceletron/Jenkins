resource "aws_route" "natr" {
  count = var.gwtype == "NAT" ? 1 : 0
  route_table_id            = var.rt_id
  destination_cidr_block    = var.rt_cidr
  nat_gateway_id = var.gwid
  
}
resource "aws_route" "igwr" {
  count = var.gwtype == "IGW" ? 1 : 0
  route_table_id            = var.rt_id
  destination_cidr_block    = var.rt_cidr
  gateway_id = var.gwid
}
resource "aws_route" "egwr" {
    count = var.gwtype == "EGW" ? 1 : 0
  route_table_id            = var.rt_id
  destination_cidr_block    = var.rt_cidr
  egress_only_gateway_id = var.gwid    
}

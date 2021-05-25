provider "aws" { 
  region= "us-east-1"
  secret_key = var.sec_key
  access_key = var.acc_key
}

data "aws_availability_zones" "example" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}
/*
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.*"]
  }

  owners = ["661984667850","amazon"]
}
/*
output "ami" {

  value = data.aws_ami.ubuntu.id 
}
/*
resource "aws_instance" "foo" {
  ami           = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro"
  key_name = "test-keypair"
  /*provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo amazon-linux-extras install nginx1",
      "service nginx start"
    ]
  }/ 
}*/

/*resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1a"
  size              = 40

  tags = {
    Name = "HelloWorld"
  }
}*/
/*
resource "aws_vpc" "my_vpc" {
  cidr_block = var.ipblock
  tags = {
    for tag in var.tags_custom:
    tag.name => tag.val
  }
}
*/
locals {
  cidr_blk_pub =cidrsubnets("10.11.0.0/24",2,2,2)
  cidr_blk_pvt=cidrsubnets("10.11.1.0/24",2,2,2)
  azone = [for i in range(3): data.aws_availability_zones.example.names[i]]
}


locals { 
  
  pub_subne= [
    for i in range(3): 
      { ip = local.cidr_blk_pub[i], name = "Public-${data.aws_availability_zones.example.names[i]}", az = data.aws_availability_zones.example.names[i]}
    ]
  pvt_subne= [
    for i in range(3): 
      { ip = local.cidr_blk_pvt[i], name = "Private-${data.aws_availability_zones.example.names[i]}", az = data.aws_availability_zones.example.names[i]}
    ]
}
  

module "VPC" {
  source = "./modules/VPC/VPC"
  ipblock ="10.11.0.0/16"
  vpc_tag = [
    {name = "Name" 
    val = "${var.project-name}-VPC" },
    {name = "Environment"
    val = var.env},
    {name = "Project"
    val = var.project-name}
  ]
}
module "Subnet-pub"{
  source = "./modules/VPC/Subnet"
  for_each = {for sub in local.pub_subne:  sub.az => sub}
  vpc_id = module.VPC.vpcid
  subnet_ipblock = each.value["ip"]
  subnet_tag = [
    {name = "Name" 
    val = each.value["name"] },
    {name = "Environment"
    val = var.env},
    {name = "Project"
    val = var.project-name}
  ]
  av_zns = each.key
}

module "Subnet-pvt"{
  source = "./modules/VPC/Subnet"
  for_each = {for sub in local.pvt_subne:  sub.az => sub}
  vpc_id = module.VPC.vpcid
  subnet_ipblock = each.value["ip"]
  subnet_tag = [
    {name = "Name" 
    val = each.value["name"] },
    {name = "Environment"
    val = var.env},
    {name = "Project"
    val = var.project-name}
  ]
  av_zns = each.key
}

module "IGW" {
  source = "./modules/VPC/Gateways/IGW"
  vpcid = module.VPC.vpcid
  igw_tag = [
    {name = "Name" 
    val = "${project-name}-IGW"},
    {name = "Environment"
    val = var.env},
    {name = "Project"
    val = var.project-name}
  ]
}
module "NAT" {
  source = "./modules/VPC/Gateways/NAT"
  sub_id = module.Subnet-pvt[local.azone[0]].subnetid
  nat_tag = [
    {name = "Name" 
    val = "${project-name}-NAT"},
    {name = "Environment"
    val = var.env},
    {name = "Project"
    val = var.project-name}
  ]
  nat_ip_tag = [
    {name = "Name" 
    val = "${project-name}-NAT-IP"},
    {name = "Environment"
    val = var.env},
    {name = "Project"
    val = var.project-name}
  ]
}

output "azs" {
  value = [for i in local.azone: module.Subnet-pvt[i].subnetid]
  description = "Private subnet ids"
}


output "ipbl" {
  value = local.cidr_blk_pvt
}

output "ipbl1" {
  value = local.cidr_blk_pub
}
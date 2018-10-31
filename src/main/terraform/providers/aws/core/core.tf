#/*
# * Copyright (c) 2018 KPN
# *
# * Permission is hereby granted, free of charge, to any person obtaining
# * a copy of this software and associated documentation files (the
# * "Software"), to deal in the Software without restriction, including
# * without limitation the rights to use, copy, modify, merge, publish,
# * distribute, sublicense, and/or sell copies of the Software, and to
# * permit persons to whom the Software is furnished to do so, subject to
# * the following conditions:
# *
# * The above copyright notice and this permission notice shall be
# * included in all copies or substantial portions of the Software.
#
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#*/

locals {
  red_nat_ids = "${module.subnet_red.nat_ids}"
}

# VPC Sub modules
module "subnet_red" {
	source = "./net"
	
	vpc_id								= "${aws_vpc.vpc.id}"
	vpc_enable_ipv6						= "${var.vpc["vpc.enable_ipv6"]}"
	vpc_default_route_table_id 			= "${aws_vpc.vpc.default_route_table_id}"
	
	subnetPrefix						= "${var.sz_red["red.subnetPrefix"]}"
	subnetTier							= "${var.sz_red["red.tagTier"]}"
	numberOfSubnets						= "${var.sz_red["red.numberOfSubnets"]}"
	indexOfSubnets						= "${var.sz_red["red.subnetStartIndex"]}"
	
	nameOfRoutingTable					= "${var.sz_red["red.tagNameRT"]}"
	ipv4Routes							= "${split(",",var.sz_red["red.ipv4Egress"])}"
	ipv6Routes							= "${split(",",var.sz_red["red.ipv6Egress"])}"
	
	nat_ids								= "${list()}"
	
	igwId								= "${aws_internet_gateway.default_internet_gateway.id}"
	eoIgwId								= "${aws_egress_only_internet_gateway.eo_ig.id}"
	
	usePublicSubnetRouteTables			= true
	usePrivateSubnetRouteTables			= false
}

module "subnet_orange" {
	source = "./net"
	
	vpc_id								= "${aws_vpc.vpc.id}"
	vpc_enable_ipv6						= "${var.vpc["vpc.enable_ipv6"]}"
	vpc_default_route_table_id 			= "${aws_vpc.vpc.default_route_table_id}"
	
	subnetPrefix						= "${var.sz_orange["orange.subnetPrefix"]}"
	subnetTier							= "${var.sz_orange["orange.tagTier"]}"
	numberOfSubnets						= "${var.sz_orange["orange.numberOfSubnets"]}"
	indexOfSubnets						= "${var.sz_orange["orange.subnetStartIndex"]}"
	
	nameOfRoutingTable					= "${var.sz_orange["orange.tagNameRT"]}"
	ipv4Routes							= "${split(",",var.sz_orange["orange.ipv4Egress"])}"
	ipv6Routes							= "${split(",",var.sz_orange["orange.ipv6Egress"])}"
	
	nat_ids								= "${local.red_nat_ids}"
	
	igwId								= "${aws_internet_gateway.default_internet_gateway.id}"
	eoIgwId								= "${aws_egress_only_internet_gateway.eo_ig.id}"
	
	usePublicSubnetRouteTables			= false
	usePrivateSubnetRouteTables			= true
}

# VPC Instance
resource "aws_vpc" "vpc" {
	cidr_block							= "${var.vpc["vpc.cidr"]}"
	enable_dns_hostnames				= "${var.vpc["vpc.enable_dns_hostnames"]}"
	enable_dns_support					= "${var.vpc["vpc.enable_dns_support"]}"
	assign_generated_ipv6_cidr_block 	= "${var.vpc["vpc.enable_ipv6"]}"
	
	tags {
		Name							= "${var.vpc["vpc.tagName"]}"
	}
}

# Internet and NAT Gateways
resource "aws_egress_only_internet_gateway" "eo_ig" {
	vpc_id								= "${aws_vpc.vpc.id}"
}

resource "aws_internet_gateway" "default_internet_gateway" {
	vpc_id								= "${aws_vpc.vpc.id}"
	
	tags {
		Name = "Default_IGW_by_TF"
	}
}

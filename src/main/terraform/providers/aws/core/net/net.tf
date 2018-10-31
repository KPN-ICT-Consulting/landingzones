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

data "aws_vpc" "vpc" {
	id 									= "${var.vpc_id}"
}

data "aws_availability_zones" "available" {}

data "aws_subnet_ids" "subnetIds" {
	vpc_id								= "${var.vpc_id}"
	depends_on							= ["aws_subnet.subnet"]
	
	tags {
		Tier							= "${var.subnetTier}"
	}
}

# NAT Gateways
resource "aws_nat_gateway" "nat_gw" {
	count								= "${var.count ? (var.usePublicSubnetRouteTables ? var.numberOfSubnets : 0) : 0}"
	
	allocation_id 						= "${element(aws_eip.nat_eip.*.id, count.index)}"
	subnet_id							= "${element(data.aws_subnet_ids.subnetIds.ids, count.index)}"
}

resource "aws_eip" "nat_eip" {
	count								= "${var.count ? (var.usePublicSubnetRouteTables ? var.numberOfSubnets : 0) : 0}"
	vpc									= true
}
# Subnets
resource "aws_subnet" "subnet" {
	count								= "${var.count ? var.numberOfSubnets : 0}"
	
	vpc_id								= "${data.aws_vpc.vpc.id}"
	cidr_block							= "${cidrsubnet(data.aws_vpc.vpc.cidr_block, 4, (count.index + var.indexOfSubnets))}"
	ipv6_cidr_block						= "${var.vpc_enable_ipv6 ? cidrsubnet(data.aws_vpc.vpc.ipv6_cidr_block, 8, (count.index + var.indexOfSubnets)) : ""}"
	availability_zone					= "${element(data.aws_availability_zones.available.names, ceil(count.index))}"
	assign_ipv6_address_on_creation		= "${var.vpc_enable_ipv6 ? "true" : "false"}"
	
	tags {
		Name							= "${format("%s_%d_%s",var.subnetPrefix, (count.index + var.indexOfSubnets), element(data.aws_availability_zones.available.names, ceil(count.index)))}"
		Tier							= "${var.subnetTier}"
	}
}

#
# Custom Route Tables and routes
#
#
# Private routes
#
resource "aws_route_table" "private_route_table" {
	count								= "${var.usePrivateSubnetRouteTables ? var.numberOfSubnets : 0}"
	vpc_id            					= "${data.aws_vpc.vpc.id}"

	tags {
		Name 							= "${format("%s_%d", var.nameOfRoutingTable, count.index)}"
	}
}
resource "aws_route" "priv_r_ipv4" {
	count								= "${var.usePrivateSubnetRouteTables ? var.numberOfSubnets : 0}"
	route_table_id            			= "${element(aws_route_table.private_route_table.*.id, count.index)}"
	nat_gateway_id         				= "${element(var.nat_ids, count.index)}"
	destination_cidr_block    			= "${element(var.ipv4Routes, 0)}"
}
resource "aws_route" "priv_r_ipv6" {
	count								= "${var.usePrivateSubnetRouteTables ? var.numberOfSubnets : 0}"
	route_table_id            			= "${element(aws_route_table.private_route_table.*.id, count.index)}"
	destination_ipv6_cidr_block		 	= "${element(var.ipv6Routes, 0)}"
	egress_only_gateway_id 				= "${var.eoIgwId}"
}
resource "aws_route_table_association" "priv_rta" {
	count								= "${var.usePrivateSubnetRouteTables ? var.numberOfSubnets : 0}"
	subnet_id      						= "${element(data.aws_subnet_ids.subnetIds.ids, count.index)}"
	route_table_id 						= "${element(aws_route_table.private_route_table.*.id, count.index)}"
}
#
# Public routes
#
resource "aws_route_table" "public_route_table" {
	count								= "${var.usePublicSubnetRouteTables ? (var.numberOfSubnets - 1) : 0}"
	vpc_id            					= "${data.aws_vpc.vpc.id}"

	tags {
		Name 							= "${format("%s_%d", var.nameOfRoutingTable, count.index)}"
	}
}
resource "aws_route" "pub_r_ipv4" {
	count								= "${var.usePublicSubnetRouteTables ? (var.numberOfSubnets - 1) : 0}"
	route_table_id            			= "${element(aws_route_table.public_route_table.*.id, count.index)}"
	destination_cidr_block    			= "${element(var.ipv4Routes, 0)}"
	gateway_id 							= "${var.igwId}"
}
resource "aws_route" "pub_r_ipv6" {
	count								= "${var.usePublicSubnetRouteTables ? (var.numberOfSubnets - 1) : 0}"
	route_table_id            			= "${element(aws_route_table.public_route_table.*.id, count.index)}"
	destination_ipv6_cidr_block 		= "${element(var.ipv6Routes, 0)}"
	egress_only_gateway_id 				= "${var.eoIgwId}"
}
resource "aws_route_table_association" "pub_rta" {
	count								= "${var.usePublicSubnetRouteTables ? (var.numberOfSubnets - 1) : 0}"
	subnet_id      						= "${element(data.aws_subnet_ids.subnetIds.ids, (count.index + 1))}" # Leave the first subnet for the default/Main RT
	route_table_id 						= "${element(aws_route_table.public_route_table.*.id, count.index)}"
}
#
# Default Route Table and routes
#
resource "aws_default_route_table" "default_route" { # same as dmz
	count								= "${var.usePublicSubnetRouteTables}"
	default_route_table_id 				= "${var.vpc_default_route_table_id}"
	
	tags {
		Name 							= "${format("%s_%s", var.nameOfRoutingTable, "Main")}"
	}
}
resource "aws_route" "r_ipv4_def" {
	count								= "${var.usePublicSubnetRouteTables ? 1 : 0}"
	route_table_id            			= "${aws_default_route_table.default_route.id}"
	destination_cidr_block    			= "${element(var.ipv4Routes, 0)}"
	gateway_id 							= "${var.igwId}"
}
resource "aws_route" "r_ipv6_def" {
	count								= "${var.usePublicSubnetRouteTables ? 1 : 0}"
	route_table_id            			= "${aws_default_route_table.default_route.id}"
	destination_ipv6_cidr_block			= "${element(var.ipv6Routes, 0)}"
	egress_only_gateway_id 				= "${var.eoIgwId}"
}
resource "aws_route_table_association" "rta_def" {
	count								= "${var.usePublicSubnetRouteTables ? 1 : 0}"
	subnet_id      						= "${element(data.aws_subnet_ids.subnetIds.ids, 0)}" # Use the first subnet in the list
	route_table_id 						= "${aws_default_route_table.default_route.id}"
}

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

#
# DATA
#
data "aws_subnet" "currentSZ" {
	count 				= "${var.numberOfSubnets}"
	id					= "${var.sz_subnet_ids[count.index]}"
}

#
# Custom Security Group and rules
#
resource "aws_security_group" "sg_sz" {
	count				= "${var.createCluster ? var.useCustomSG : 0}"
	vpc_id     		  	= "${var.vpc_id}"
	name        		= "${var.nameOfSG}"
	description 		= "Used in ${var.nameOfCluster}"
		
	tags {
		Name			= "${var.nameOfSG}"
		Cluster       	= "${var.nameOfCluster}"
		InstanceGroup 	= "${var.nameOfCluster}"
	}
}
# We separate the rules from the aws_security_group because then we can manipulate the 
# aws_security_group outside of this module
resource "aws_security_group_rule" "outbound_access" {
	count				= "${var.createCluster ? var.useCustomSG : 0}"
	type              	= "egress"
	from_port         	= 0
	to_port           	= 0
	protocol          	= "-1"
	cidr_blocks       	= ["0.0.0.0/0"]
	ipv6_cidr_blocks  	= ["::/0"]
	security_group_id 	= "${aws_security_group.sg_sz.id}"
}
resource "aws_security_group_rule" "inbound_access" {
	count				= "${var.createCluster ? (var.useCustomSG ? length(compact(split(",",var.ingressPorts))) : 0) : 0}"
	type              	= "ingress"
	from_port         	= "${element(split(",",var.ingressPorts), count.index)}"
	to_port           	= "${element(split(",",var.ingressPorts), count.index)}"
	protocol          	= "tcp"														#we assume tcp only for now
	cidr_blocks       	= ["${data.aws_subnet.currentSZ.*.cidr_block}"]
	ipv6_cidr_blocks  	= ["${data.aws_subnet.currentSZ.*.ipv6_cidr_block}"]
	security_group_id 	= "${aws_security_group.sg_sz.id}"
}

#
# Default Security Group and rules
#
resource "aws_default_security_group" "default_sg" { # same as Red
	count				= "${var.createCluster ? (var.useDefaultSG ? length(compact(split(",",var.ingressPorts))) : 0) : 0}"
	vpc_id     		  	= "${var.vpc_id}"
	
	ingress {
		from_port   	= "${element(split(",",var.ingressPorts), 0)}"
		to_port     	= "${element(split(",",var.ingressPorts), 0)}"
		protocol    	= "tcp"													#we assume tcp only for now
		cidr_blocks 	= ["${data.aws_subnet.currentSZ.*.cidr_block}"]
		ipv6_cidr_blocks= ["${data.aws_subnet.currentSZ.*.ipv6_cidr_block}"]
  	}

	ingress {
		from_port   	= "${element(split(",",var.ingressPorts), 1)}"
		to_port     	= "${element(split(",",var.ingressPorts), 1)}"
		protocol    	= "tcp"													#we assume tcp only for now
		cidr_blocks 	= ["${data.aws_subnet.currentSZ.*.cidr_block}"]
		ipv6_cidr_blocks= ["${data.aws_subnet.currentSZ.*.ipv6_cidr_block}"]
  	}
  
	egress {
		from_port   	= 0
		to_port     	= 0
		protocol    	= "-1"
		cidr_blocks 	= ["0.0.0.0/0"]
		ipv6_cidr_blocks= ["::/0"]
  	}
  
	tags {
		Name			= "${var.nameOfSG}"
		Cluster       	= "${var.nameOfCluster}"
		InstanceGroup 	= "${var.nameOfCluster}"
	}
}

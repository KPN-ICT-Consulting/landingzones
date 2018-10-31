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
# ECS
#
module "ecs-cluster-red" {
	source = "./ec2"
	
	vpc_id 					= "${var.vpc_id}"
	numberOfSubnets			= "${var.sz_red["red.numberOfSubnets"]}"
	sz_subnet_ids			= "${var.red_subnet_ids}"
	nameOfTier				= "${var.sz_red["red.tagTier"]}"
	nameOfCluster			= "${"n.a."}"
	
	ami						= "${var.ecs_optimized_amis[var.region]}"
	instanceType			= "${var.ecs-clusters["red.instanceType"]}"
	spot_price				= "${var.spot_pricing[var.region]}"
	min						= "${var.ecs-clusters["red.min"]}"
	max						= "${var.ecs-clusters["red.max"]}"
	desiredCapacity			= "${var.ecs-clusters["red.desiredCapacity"]}"
	
	iam_instance_profile 	= "${aws_iam_instance_profile.ecs.id}"
	
	nameOfSG				= "${var.ecs-clusters["red.nameOfSG"]}"
	ingressPorts			= "${var.ecs-clusters["red.ingressPorts"]}"
	egressPorts				= "${var.ecs-clusters["red.egressPorts"]}"
	
	region					= "${var.region}"
	cloudwatch_prefix		= "${var.cloudwatch_prefix}"
	
	createCluster			= "${var.ecs-clusters["red.createCluster"]}"
	useDefaultSG			= true
	useCustomSG				= false
}

module "ecs-cluster-orange" {
	source = "./ec2"
	
	vpc_id 					= "${var.vpc_id}"
	numberOfSubnets			= "${var.sz_orange["orange.numberOfSubnets"]}"
	sz_subnet_ids			= "${var.orange_subnet_ids}"
	nameOfTier				= "${var.sz_orange["orange.tagTier"]}"
	nameOfCluster			= "${var.ecs-clusters["orange.nameOfCluster"]}"
	
	ami						= "${var.ecs_optimized_amis[var.region]}"
	instanceType			= "${var.ecs-clusters["orange.instanceType"]}"
	spot_price				= "${var.spot_pricing[var.region]}"
	min						= "${var.ecs-clusters["orange.min"]}"
	max						= "${var.ecs-clusters["orange.max"]}"
	desiredCapacity			= "${var.ecs-clusters["orange.desiredCapacity"]}"
	
	iam_instance_profile 	= "${aws_iam_instance_profile.ecs.id}"
	
	nameOfSG				= "${var.ecs-clusters["orange.nameOfSG"]}"
	ingressPorts			= "${var.ecs-clusters["orange.ingressPorts"]}"
	egressPorts				= "${var.ecs-clusters["orange.egressPorts"]}"
	
	region					= "${var.region}"
	cloudwatch_prefix		= "${var.cloudwatch_prefix}"
	
	createCluster			= "${var.ecs-clusters["orange.createCluster"]}"
	useDefaultSG			= false
	useCustomSG				= true
}

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
# Load Balancers
#
module "load_balancers" {
	source = "./load-balancers"
	
	vpc_id 					= "${var.vpc_id}"
	ecs-clusters			= "${var.ecs-clusters}"
	subnet_ids				= "${var.red_subnet_ids}"
	
}

#
# CLUSTER
#
module "ecs_clusters" {
	source = "./ecs-clusters"

	vpc_id 					= "${var.vpc_id}"
	red_subnet_ids			= "${var.red_subnet_ids}"
	orange_subnet_ids		= "${var.orange_subnet_ids}"
	ecs-clusters			= "${var.ecs-clusters}"
	sz_red 					= "${var.sz_red}"
  	sz_orange 				= "${var.sz_orange}"	
	
	region					= "${var.region}"
	ecs_optimized_amis		= "${var.ecs_optimized_amis}"
	spot_pricing			= "${var.spot_pricing}"
	
	cloudwatch_prefix		= "${var.cloudwatch_prefix}"
	
}


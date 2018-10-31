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

provider "aws" {
	#assume_role {
    #	role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
    #	session_name = "SESSION_NAME"
    #	external_id  = "EXTERNAL_ID"
  	#}
	region 				= "${var.region}"
}

module "root_dns" {
#outs: "${module.root_dns.root_zone_id}"
	source = "./dns"
	
	count 				= "${var.configureDNS}"
	
	domain 				= "${var.root_domain["domain"]}"
	domain_identifier 	= "${var.root_domain["domain_identifier"]}"
}

module "core" {
#outs: "${module.core.vpc_id}"
#      "${module.core.red_subnet_ids}"
#      "${module.core.orange_subnet_ids}"
	source = "./core"

	count 				= "${var.configureVPC}"
	
	vpc    				= "${var.vpc}"
	sz_red 				= "${var.sz_red}"
  	sz_orange 			= "${var.sz_orange}"
	
	#cloudwatch_prefix 	= "${var.cloudwatch_prefix}"
}

module "sps" {
#outs: "${module.sps.alb_id}"
#      "${module.sps.alb_name}"
#      "${module.sps.sg_alb_id}"
	source = "./sps"

	vpc_id				= "${module.core.vpc_id}"
	red_subnet_ids		= "${module.core.red_subnet_ids}"
	orange_subnet_ids	= "${module.core.orange_subnet_ids}"
	sz_red 				= "${var.sz_red}"
  	sz_orange 			= "${var.sz_orange}"
	ecs-clusters		= "${var.ecs-clusters}"	

	ecs_optimized_amis	= "${var.ecs_optimized_amis}"
	spot_pricing		= "${var.spot_pricing}"
		
	cloudwatch_prefix	= "${var.cloudwatch_prefix}"
	region				= "${var.region}"

}
#module "iam" {
#	source = "./iam"
#	
#}
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

#variable "staging" {
#	description = "set to true if the Staging environment should be created. For Production set to false."
	# Set thru commandline
#}
#variable "branch_based_region" {
#	description = "The region used related to the branch. Fx development=eu-west1 or master=eu-west-2"
#	type = "string"
#	default = BRANCH_BASED_REGION
#}
variable "root_domain" {
	description = "Root domain configuration"
	type = "map"
	default = {
		doCreate					= true		# Only create once, then set this value to false.
		domain 						= "kpn-ictc-mapps.com"
		domain_weight 				= "10"
		domain_identifier			= "Prod"
	}
}
variable "vpc" {
	description = "VPC Configuration"
	default = {
		vpc.cidr					= "10.0.0.0/16"
		vpc.enable_ipv6				= true
		vpc.enable_dns_hostnames 	= "true"
		vpc.enable_dns_support		= "true"
		vpc.tagName					= "TF_VPC"
	}
}
variable "sz_red" {
	description = ""
	default = {
		red.subnetPrefix			= "RED-SN"
		red.numberOfSubnets			= "2"
		red.subnetStartIndex		= "0"
		red.tagTier					= "RED"
		red.tagNameRT				= "RED_Routing_Table_TF"
		red.ipv4Egress				= "0.0.0.0/0"
		red.ipv6Egress				= "::/0"
	}
}
variable "sz_orange" {
	description = ""
	default = {
		orange.subnetPrefix			= "ORANGE-SN"
		orange.numberOfSubnets		= "2"
		orange.subnetStartIndex		= "2"
		orange.tagTier				= "ORANGE"
		orange.tagNameRT			= "ORANGE_Routing_Table_TF"
		orange.ipv4Egress			= "0.0.0.0/0"
		orange.ipv6Egress			= "::/0"
	}
}
# ==== ECS Cluster variables ====
variable "ecs-clusters" {
	description = ""
	default = {
		# Red
		red.nameOfCluster 		= "red-cluster"
		red.instanceType		= "t2.medium"
		red.min					= "3"
		red.max					= "24"
		red.desiredCapacity		= "3"
		red.lb_type				= "alb"			# Application Load Balancer
		red.lb_name				= "ECS-ALB"
		red.createCluster		= false
		
		red.nameOfSG 			= "SG_RED"
		red.ingressPorts		= "" #80,443
		red.egressPorts			= ""
		
		# Orange
		orange.nameOfCluster 	= "orange-cluster"
		orange.instanceType		= "t2.medium"
		orange.min				= "3"
		orange.max				= "48"
		orange.desiredCapacity	= "3"
		orange.createCluster	= false

		orange.nameOfSG 		= "SG_ORANGE"
		orange.ingressPorts		= "80,443,8080"
		orange.egressPorts		= ""
	}
}
# ==== EC2 and ECS Instance variables ====
variable "ecs_optimized_amis" {
	description = ""
	type = "map"
	default = { 
		"eu-central-1" 	= "ami-3b7d1354"
		"eu-west-1" 	= "ami-64c4871d" 
	}
}
variable "spot_pricing" {
	description = ""
	type = "map"
	default = { 
		"eu-central-1" 	= "0.0536" 
		"eu-west-1" 	= "0.0536" 
	}
}
# ==== Cloudwatch variables ====
variable "cloudwatch_prefix" {
	description = "Prefix for Cloudwatch to separate log groups"
	default     = "" # To avoid cloudwatch collision or if you don't want to merge all logs to one log group specify a prefix
}



###########################################################################################
# ENABLE / DISABLE parts of configuration
###########################################################################################
variable "configureDNS" {
	description = "set to true if DNS should be created."
	default = "true"
}
variable "configureVPC" {
	description = "set to true if VPC should be created."
	default = "true" #NOTE that only true works for now. FALSE WILL FAIL FOR NOW!!!
}
variable "configureECS" {
	description = "set to true if ECS (not Fargate) should be created."
	default = "false"
}

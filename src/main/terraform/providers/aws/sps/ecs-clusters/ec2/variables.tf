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
# ECS Cluster variables
#
variable "vpc_id" {
  description = "VPC ID generated on creation of the VPC"
}
variable "sz_subnet_ids" {
	description = ""
	type = "list"
}
variable "numberOfSubnets" {
	description = ""
}
variable "nameOfTier" {
	description = ""
}
variable "nameOfCluster" {
	description = ""
}
variable "ami" {
	description = ""
}
variable "instanceType" {
	description = "Instance type"
}
variable "spot_price" {
	description = ""
}
variable "min" {
	description = ""
}
variable "max" {
	description = ""
}
variable "desiredCapacity" {
	description = ""
}
variable "iam_instance_profile" {
	description = ""
}
variable "nameOfSG" {
	description = ""
}
variable "ingressPorts" {
	description = ""
}
variable "egressPorts" {
	description = ""
}
variable "useDefaultSG" {
	description = ""
}
variable "useCustomSG" {
	description = ""
}
variable "createCluster" {
	description = "Boolean which creates a ECS cluster or does nothing"
}
variable "custom_userdata" {
	description = "Inject extra command in the instance template to be run on boot"
	default     = ""
}
variable "ecs_logging" {
	description = "Adding logging option to ECS that the Docker containers can use."
	default     = "[\"json-file\",\"awslogs\"]"
}
variable "ecs_config" {
	description = "Specify ecs configuration or get it from aws storage. Fx. aws s3 cp s3://some-bucket/ecs.config /etc/ecs/ecs.config"
	default     = "echo '' > /etc/ecs/ecs.config"
}
variable "region" {
	description = "The region"
}
#
# Cloudwatch variables
#
variable "cloudwatch_prefix" {
	description = "Prefix for Cloudwatch to separate log groups."
}

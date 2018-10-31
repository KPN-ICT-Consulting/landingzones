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
# Root outputs
#
#
# VPC outputs
#
output "vpc_id" {
	description = "The ID of the VPC as configured by TF"
	value 		= "${module.core.vpc_id}"
}
output "red_subnet_ids" {
	description = "The subnet ids from Red"
	value = "${module.core.red_subnet_ids}"
}
output "orange_subnet_ids" {
	description = "The subnet ids from Orange"
	value = "${module.core.orange_subnet_ids}"
}

#
# Load Balancers outputs
#
output "alb_id" {
	value = "${module.sps.alb_id}"
}
output "alb_name" {
	value = "${module.sps.alb_name}"
}
output "sg_alb_id" {
	value = "${module.sps.sg_alb_id}"
}
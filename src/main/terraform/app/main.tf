#/*
# * Copyright (c) 2018 KPN, 
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

# Note: This file is based upon the awslabs terraform demo, located at:
#
#     https://github.com/awslabs/apn-blog/blob/tf_blog_v1.0/terraform_demo/
#
data "terraform_remote_state" "initial" {
    backend = "s3"
    config {
        bucket = "kma-terraform"
		key    = "terraform/NAME_TO_SET_LZ_TFSTATE"
        region = "BRANCH_BASED_REGION"
    }
}
	
module "aws" {
	source = "./providers/aws"
	
	region 				= "BRANCH_BASED_REGION"
  	#isStaging			= "${var.staging}"
  	vpc_id 				= "${data.terraform_remote_state.initial.vpc_id}"
  	red_subnet_ids		= "${data.terraform_remote_state.initial.red_subnet_ids}"
  	orange_subnet_ids	= "${data.terraform_remote_state.initial.orange_subnet_ids}"
  	
  	app_configuration	= "${var.app_configuration}"
  	
  	cloudwatch_prefix 	= "${var.cloudwatch_prefix}"
}

terraform {
	required_version = "> 0.7.0"
	backend "s3" {
		bucket = "kma-terraform"
		key    = "terraform/NAME_TO_SET_LZ_FGAPP_TFSTATE"
		region = "BRANCH_BASED_REGION"
	}
}


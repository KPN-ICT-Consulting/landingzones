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
data "template_file" "user_data" {
	template = "${file("${path.module}/templates/user_data.sh")}"
	
	vars {
		ecs_config        = "${var.ecs_config}"
		ecs_logging       = "${var.ecs_logging}"
		cluster_name      = "${var.nameOfCluster}"
		custom_userdata   = "${var.custom_userdata}"
		cloudwatch_prefix = "${var.cloudwatch_prefix}"
	}
}

#
# ECS Instances
#
# You can have multiple ECS clusters in the same account with different resources.
# Therefore all resources created here have the name containing the name of the:
# environment, cluster name en the instance_group name.
# That is also the reason why ecs_instances is a seperate module and not everything is created here.

# Default disk size for Docker is 22 gig, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
resource "aws_launch_configuration" "launch" {
	count						= "${var.createCluster}"
	name_prefix          		= "${var.nameOfCluster}_"
	image_id             		= "${var.ami}"
	instance_type        		= "${var.instanceType}"
	spot_price 					= "${var.spot_price}"
	security_groups      		= ["${var.useDefaultSG ? join("",aws_default_security_group.default_sg.*.id) : join("",aws_security_group.sg_sz.*.id)}"]
	user_data            		= "${data.template_file.user_data.rendered}"
	iam_instance_profile 		= "${var.iam_instance_profile}"
	
	# aws_launch_configuration can not be modified.
	# Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created
	# before the old one get's destroyed. That's why we use name_prefix instead of name.
	lifecycle {
		create_before_destroy 	= true
	}
}

# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html 
resource "aws_autoscaling_group" "asg" {
	count						= "${var.createCluster}"
	name                 		= "${var.nameOfCluster}"
	min_size             		= "${var.min}"
	max_size             		= "${var.max}"
	desired_capacity     		= "${var.desiredCapacity}"
	force_delete         		= false
	launch_configuration 		= "${aws_launch_configuration.launch.id}"
	vpc_zone_identifier  		= ["${var.sz_subnet_ids}"]
	
	tag {
		key                 	= "Name"
		value               	= "${var.nameOfCluster}"
		propagate_at_launch 	= "true"
	}

	tag {
		key                 	= "Cluster"
		value               	= "${var.nameOfCluster}"
		propagate_at_launch 	= "true"
	}

	tag {
		key                 	= "InstanceGroup"
		value               	= "${var.nameOfCluster}"
		propagate_at_launch 	= "true"
	}
}


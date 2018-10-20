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

# ALB Security group
# This is the group you need to edit if you want to restrict access to your application
resource "aws_security_group" "sg_alb" {
  	name        			= "TF-ECS-ALB"
  	description 			= "Controls access to the App ALB"
  	vpc_id      			= "${var.vpc_id}"

  	ingress {
    	protocol    		= "tcp"
    	from_port   		= 80
    	to_port     		= 80
    	cidr_blocks 		= ["0.0.0.0/0"]
  	}

  	egress {
    	from_port 			= 0
    	to_port   			= 0
    	protocol  			= "-1"
    	cidr_blocks 		= ["0.0.0.0/0"]
  	}
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
	name        			= "TF-ECS-TASKS"
  	description 			= "Allow inbound access from the ALB only"
  	vpc_id      			= "${var.vpc_id}"

  	ingress {
    	protocol        	= "tcp"
    	from_port       	= "${var.app_configuration["app.port"]}"
    	to_port         	= "${var.app_configuration["app.port"]}"
    	security_groups 	= ["${aws_security_group.sg_alb.id}"]
  	}

  	egress {
    	protocol    		= "-1"
    	from_port   		= 0
    	to_port     		= 0
    	cidr_blocks 		= ["0.0.0.0/0"]
  	}
}

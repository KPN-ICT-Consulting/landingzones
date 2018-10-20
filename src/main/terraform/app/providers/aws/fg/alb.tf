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

resource "aws_alb" "alb" {
	name            		= "TF-ECS-ALB-APP"
	subnets         		= ["${var.subnet_ids}"] #maybe use red instead of orange
	security_groups 		= ["${aws_security_group.sg_alb.id}"]
}

resource "aws_alb_target_group" "app" {
	name        			= "TF-ECS-APP"
	port        			= 80
	protocol    			= "HTTP"
	vpc_id      			= "${var.vpc_id}"
	target_type 			= "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
	load_balancer_arn 		= "${aws_alb.alb.id}"
	port              		= "80"
	protocol          		= "HTTP"

  	default_action {
    	target_group_arn 	= "${aws_alb_target_group.app.id}"
    	type             	= "forward"
  	}
}

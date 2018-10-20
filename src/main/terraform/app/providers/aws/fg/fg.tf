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

resource "aws_ecs_cluster" "main" {
	name = "tf-ecs-cluster"
}

resource "aws_ecs_task_definition" "app" {
	family                   = "app"
	network_mode             = "awsvpc"
	requires_compatibilities = ["FARGATE"]
	cpu                      = "${var.app_configuration["fargate.cpu"]}"
	memory                   = "${var.app_configuration["fargate.memory"]}"
	
	container_definitions = <<DEFINITION
[
  {
    "cpu": ${var.app_configuration["fargate.cpu"]},
    "image": "${var.app_configuration["app.image"]}",
    "memory": ${var.app_configuration["fargate.memory"]},
    "name": "app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.app_configuration["app.port"]},
        "hostPort": ${var.app_configuration["app.port"]}
      }
    ]
  }
]
DEFINITION
}

resource "aws_ecs_service" "main" {
	name            = "tf-ecs-service"
	cluster         = "${aws_ecs_cluster.main.id}"
	task_definition = "${aws_ecs_task_definition.app.arn}"
	desired_count   = "${var.app_configuration["app.count"]}"
	launch_type     = "FARGATE"

	network_configuration {
		security_groups = ["${aws_security_group.ecs_tasks.id}"]
		subnets         = ["${var.subnet_ids}"]
	}

	load_balancer {
		target_group_arn = "${aws_alb_target_group.app.id}"
		container_name   = "app"
		container_port   = "${var.app_configuration["app.port"]}"
	}

	depends_on = [
		"aws_alb_listener.front_end",
  	]
}

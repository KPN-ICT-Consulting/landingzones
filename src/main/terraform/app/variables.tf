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
variable "app_configuration" {
	description = "The configuration of the application to deploy to fargate"
	type = "map"
	default = {
		app.image					= "adongy/hostname-docker:latest"
		app.port					= "3000" #Port exposed by the docker image to redirect traffic to
		app.count 					= "2"
		fargate.cpu					= "256" #Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)
		fargate.memory				= "512" #Fargate instance memory to provision (in MiB)
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

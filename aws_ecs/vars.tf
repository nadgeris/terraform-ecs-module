variable "AWS_REGION" {
  default = "us-east-1"
}

variable "ECS_INSTANCE_TYPE" {}

variable "ECS_AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0babb0c4a4e5769b8"
    us-west-2 = "ami-56ed4936"
    eu-west-1 = "ami-c8337dbb"
  }
}

variable "ecs_cluster_name" {}
variable "env" {}
variable "service" {}

variable "key_name" {}
variable "security_group" {}
variable "subnet-1a" {}
variable "subnet-1b" {}
variable "min_instances" {}
variable "max_instances" {}

variable "ecr" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

module "ecs_cluster" {
  source  = "./aws_ecs"
  env = "QE"
  ECS_INSTANCE_TYPE = "t2.small"
  min_instances = "1"
  max_instances = "2"
  service = "testing"
  key_name = "Sagar"
  ecs_cluster_name = "testing-ecs"
  security_group = "sg-***********"
  subnet-1a = "subnet-**************"
  subnet-1b = "subnet-**************"
  ecr = ["abtest", "snyper"]
}

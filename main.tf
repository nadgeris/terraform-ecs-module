module "ecs_cluster" {
  source  = "./aws_ecs"
  env = "QE"
  ECS_INSTANCE_TYPE = "t2.small"
  min_instances = "1"
  max_instances = "2"
  service = "testing"
  key_name = "Sagar"
  ecs_cluster_name = "testing-ecs"
  security_group = "sg-066a30c2c3d1fb68f"
  subnet-1a = "subnet-0d979fb6d4e72cbc9"
  subnet-1b = "subnet-07b0ae63f6d36ba93"
  ecr = ["abtest", "snyper"]
}

# terraform-modules

A Terraform module for building an ECS Cluster in AWS.

The ECS cluster requires:
existing VPC,subnets, security group


This Module will be created:
ECS clsuter with launch configuration and auto-scaling group for a cluster of ECS container instances.
An SSH key to connect to the ECS container instances.
ECR repos for application.
load balancer.

An IAM role and policy for the container instances allowing:
ECS interactions,
ECR image pulls,
S3 object fetches.

Stores the state file in S3 Location.


# How to use:

1) clone the repo:

git clone https://github.com/nadgeris/terraform-modules.git

2) update secret key, access key and region in provider.tf.

3) update ECS_INSTANCE_TYPE, key_name(ec2 key pairs), ecs_cluster_name, security_group, subnet-1a, subnet-1b in main.tf.

4) Run the below terraform command to launch ECS cluster.

  terraform init

  terraform plan

  terraform apply
  
  
The "terraform init" command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

The "terraform plan" command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state. For example, terraform plan might be run before committing a change to version control, to create confidence that it will behave as expected.

The "terraform apply" command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan.




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

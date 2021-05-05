data "template_file" "myapp-task-definition-template" {
  count = length(aws_ecr_repository.ecr.*.repository_url)
  template = file("app.json.tpl")
  vars = {
    REPOSITORY_URL = replace(element(aws_ecr_repository.ecr.*.repository_url, count.index), "https://", "")
  }
}

resource "aws_ecs_cluster" "ecs" {
    name = var.ecs_cluster_name
    tags = {
        Name = var.ecs_cluster_name
        Terraform = "true"
        Environment = var.env
        Service = var.service
    }

}

data "template_file" "user_data" {
  template = file("config/user-data.sh")

  vars = {
    cluster_name = "${aws_ecs_cluster.ecs.name}-${var.env}"
  }
}

resource "aws_launch_configuration" "ecs-launchconfig" {
  name_prefix = "ecs-launchconfig"
  image_id = var.ECS_AMIS[var.AWS_REGION]
  instance_type = var.ECS_INSTANCE_TYPE
  key_name = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
  security_groups = ["${var.security_group}"]
  user_data = data.template_file.user_data.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-autoscaling" {
  name  = "ecs-autoscaling"
  vpc_zone_identifier = ["${var.subnet-1a}", "${var.subnet-1b}"]
  launch_configuration = aws_launch_configuration.ecs-launchconfig.name
  min_size = var.min_instances
  max_size = var.max_instances
}


resource "aws_ecs_task_definition" "myapp-task-definition" {
  count = length(aws_ecr_repository.ecr.*.repository_url)
  family                = element(var.ecr,count.index)
  container_definitions = element(data.template_file.myapp-task-definition-template.*.rendered, count.index)
}

resource "aws_elb" "myapp-elb" {
  name = "myapp-elb-${var.env}"

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:8080/"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = ["${var.subnet-1a}"]
  security_groups = ["${var.security_group}"]

  tags = {
    Name = "myapp-elb-${var.env}"
  }
}

resource "aws_ecs_service" "myapp-service" {
  count = length(aws_ecr_repository.ecr.*.repository_url)
  name            = element(var.ecr,count.index)
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = element(aws_ecs_task_definition.myapp-task-definition.*.arn, count.index)
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_policy_attachment.ecs-service-attach1]

  load_balancer {
    elb_name       = aws_elb.myapp-elb.name
    container_name = "myapp"
    container_port = 8080
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}

resource "aws_launch_template" "app_server" {
  image_id      = "ami-0557a15b87f6559cf"
  instance_type = var.instance
  key_name = var.key
  tags = {
      Name = var.tag
  
      }
  security_group_names = [ var.security_group ]
  user_data = var.prod ? filebase64("ansible.sh") : ""
}

resource "aws_key_pair" "sshKeys" {
  key_name = var.key
  public_key = file("${var.key}.pub")
  
}

resource "aws_autoscaling_group" "elastic_group" {
  availability_zones = [ "${var.region}a", "${var.region}b" ]
  name = var.elastic_group_name
  max_size =  var.max
  min_size = var.min
  target_group_arns = var.prod ? [ aws_lb_target_group.lbTarget[0].arn ] : []
  launch_template {
    id = aws_launch_template.app_server.id
    version = "$Latest"
    
  }  
}

resource "aws_default_subnet" "subnet_1" {
  availability_zone = "${var.region}a"
}

resource "aws_default_subnet" "subnet_2" {
  availability_zone = "${var.region}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false 
  subnets = [ aws_default_subnet.subnet_1.id, aws_default_subnet.subnet_2.id ]
  count = var.prod ? 1:0
}

resource "aws_lb_target_group" "lbTarget"{
  name = "instanceTgt"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
  count = var.prod ? 1:0
}

resource "aws_default_vpc" "default"{

}

resource "aws_lb_listener" "lbInbound" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lbTarget[0].arn
  }
  count = var.prod ? 1:0
}

resource "aws_autoscaling_policy" "PROD-Scale" {
  name = "TF-PROD-SCALE"
  autoscaling_group_name = var.elastic_group_name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.prod ? 1:0
}
  

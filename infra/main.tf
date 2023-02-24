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
  
}

resource "aws_key_pair" "sshKeys" {
  key_name = var.key
  public_key = file("${var.key}.pub")
  
}

resource "aws_autoscaling_group" "elastic_group" {
  availability_zones = [ "${var.region}a" ]
  name = var.elastic_group_name
  max_size =  var.max
  min_size = var.min
    launch_template {
    id = aws_launch_template.app_server.id
    version = "$Latest"
    
  }
}
  

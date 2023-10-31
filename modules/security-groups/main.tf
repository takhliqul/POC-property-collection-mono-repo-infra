################################################################
## defaults
################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_security_group" "sg" {
  count = var.create_security_group ? 1 : 0

  name        = var.name
  vpc_id      = var.vpc_id
  description = var.description

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      security_groups  = ingress.value.security_group_id != null ? ingress.value.security_group_id : []
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
      self             = ingress.value.self
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules

    content {
      description      = egress.value.description
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = egress.value.cidr_blocks
      security_groups  = egress.value.security_group_id != null ? egress.value.security_group_id : []
      ipv6_cidr_blocks = egress.value.ipv6_cidr_blocks
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
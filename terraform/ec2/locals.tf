################################################################################
## locals
################################################################################
locals {
  ## networking
  private_cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
  public_cidr_blocks  = [for s in data.aws_subnet.public : s.cidr_block]

  # ################################################################################
  # #Server Instance details
  # ################################################################################

 webservers_ec2= {
    dev = [
      {
        name          = "Applications"
        subnet_id     = data.aws_subnets.private.ids[1]
        ebs_optimized = false
        volume_size   = 50
        ami = {
          id            = "ami-0fa25f41b201c4229"
          owner         = "573622224997"
          instance_type = "m6a.xlarge"
        }
      },
      {
        name          = "Production"
        subnet_id     = data.aws_subnets.private.ids[0]
        ebs_optimized = false
        volume_size   = 50
        ami = {
          id            = "ami-0fa25f41b201c4229"
          owner         = "573622224997"
          instance_type = "m6a.xlarge"
        }
      },
       {
        name          = "RENDER"
        subnet_id     = data.aws_subnets.private.ids[0]
        ebs_optimized = false
        volume_size   = 50
        ami = {
          id            = "ami-0fa25f41b201c4229"          
          owner         = "573622224997"

          instance_type = "m6a.xlarge"
        }
      },
      {
        name          = "SSIS-DEV1"
        subnet_id     = data.aws_subnets.public.ids[0]
        ebs_optimized = false
        volume_size   = 100
        ami = {
          id            = "ami-02dadb4d3f5281a35"
          owner         = "573622224997"

          instance_type = "m6a.xlarge"
        }
      },
      {
        name          = "SSIS-DEV2"
        subnet_id     = data.aws_subnets.public.ids[1]
        ebs_optimized = false
        volume_size   = 100
        ami = {
          id            = "ami-09e0e514fd14dcaf9"
          owner         = "573622224997"

          instance_type = "m6a.xlarge"
        }
      },
      {
        name          = "cms-database-primary"
        subnet_id     = data.aws_subnets.private.ids[0]
        ebs_optimized = false
        volume_size   = 400
        ami = {
          id            = "ami-0a37cf65ae4ba59f2"
          owner         = "573622224997"

          instance_type = "m6a.2xlarge"
        }
      },
      {
        name          = "cms-database-secondary"
        subnet_id     = data.aws_subnets.private.ids[1]
        ebs_optimized = false
        volume_size   = 400
        ami = {
          id            = "ami-0ed7050f1579fc489"
          owner         = "573622224997"

          instance_type = "m6a.2xlarge"
        }
      },
      {
        name          = "domain-controller"
        subnet_id     = data.aws_subnets.private.ids[1]
        ebs_optimized = false
        volume_size   = 50
        ami = {
          id            = "ami-0fa25f41b201c4229"
          owner         = "573622224997"

          instance_type = "t3.large"
        }
      },
      {
        name          = "ntfs"
        subnet_id     = data.aws_subnets.private.ids[1]
        ebs_optimized = false
        volume_size   = 1000
        ami = {
          id            = "ami-0fa25f41b201c4229"
          owner         = "573622224997"

          instance_type = "t3.large"
        }
      },
      ]
   }

  ###securitygroups:
  ec2_security_group_rules = [
    {
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 1433
      to_port     = 1433
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 3389
      to_port     = 3389
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
 ec2_instance_attachment = {
    "Applications" = {
      target_group_arn = data.aws_lb_target_group.this.arn
      target_id        = module.ec2_webservers["Applications"].id
    }
  }
  alb = {
    "Applications" = {
      security_group_ids = module.security_groups["webserver-load-balancer-security-group"].id
    }
  }

}

  
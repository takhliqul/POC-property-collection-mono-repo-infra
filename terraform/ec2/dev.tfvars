region          = "eu-west-2"
namespace       = "pc"
environment     = "dev"
project_name    = "Property-Collection"
instance_profile = "ec2-role-eu-west-2"


#####security_group#########
sgs = {
  applications-security-group = {
    create_security_group = true,
    name                  = "applications-security-group",
    description           = "Security Group configured for our applications server",

    ingress_rules = {
      https = {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS traffic"
        from_port   = 443
        protocol    = "tcp"
        to_port     = 443
      },
      http = {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic"
        from_port   = 80
        protocol    = "tcp"
        to_port     = 80
      },
      ssh = {
        cidr_blocks = ["0.0.0.0/0"]
        description = "SSH Access"
        from_port   = 22
        protocol    = "tcp"
        to_port     = 22
      },
       sqlserver = {
        cidr_blocks = ["0.0.0.0/0"]
        description = "MSSQL Access"
        from_port   = 1433
        protocol    = "tcp"
        to_port     = 1433
      },
    },

    egress_rules = {
      allow_all = {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  },
  webserver-load-balancer-security-group = {
    create_security_group = true,
    name                  = "webserver-load-balancer-security-group",
    description           = "Security Group configured for our webserver loadbalancer",

    ingress_rules = {
      https = {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS traffic"
        from_port   = 443
        protocol    = "tcp"
        to_port     = 443
      },
      http = {
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP traffic"
        from_port   = 80
        protocol    = "tcp"
        to_port     = 80
      },
    },

    egress_rules = {
      allow_all = {
        description = "Allow all outbound traffic"
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
  }
}


##############################  ALB 

availability_zones                = ["eu-west-2a,eu-west-2b"]
load_balancer_name                = "webserver-load-balancer"
target_group_name                 = "app-target-group"
internal                          = false
http_enabled                      = true
http_redirect                     = false
access_logs_enabled               = false
cross_zone_load_balancing_enabled = false
http2_enabled                     = true
idle_timeout                      = 60
ip_address_type                   = "ipv4"
deletion_protection_enabled       = false
deregistration_delay              = 300
health_check_path                 = "/"
health_check_timeout              = 5
health_check_healthy_threshold    = 3
health_check_unhealthy_threshold  = 3
health_check_interval             = 30
health_check_matcher              = "200-399"
instance_target_group_port        = 80
target_group_port                 = 443
target_group_target_type          = "instance"
stickiness = {
  cookie_duration = 60
  enabled         = false
}
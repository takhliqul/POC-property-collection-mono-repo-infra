module "tags" {
  source = "git::https://github.com/sourcefuse/terraform-aws-refarch-tags?ref=1.2.1"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    MonoRepo     = "True"
    MonoRepoPath = "terraform/resources/eks"
  }
}

module "eks_cluster" {
  source                    = "git::https://github.com/sourcefuse/terraform-aws-ref-arch-eks?ref=4.0.1"
  environment               = var.environment
  name                      = var.name
  namespace                 = var.namespace
  desired_size              = var.desired_size
  instance_types            = var.instance_types
  kubernetes_namespace      = var.kubernetes_namespace
  max_size                  = var.max_size
  min_size                  = var.min_size
  private_subnet_names      = local.private_subnet_names
  public_subnet_names       = local.public_subnet_names
  region                    = var.region
  vpc_name                  = local.vpc_name
  tags                      = module.tags.tags
  enabled                   = true
  apply_config_map_aws_auth = true
  kube_data_auth_enabled    = true
  kube_exec_auth_enabled    = true
  csi_driver_enabled        = true
  map_additional_iam_roles  = var.map_additional_iam_roles
  kubernetes_version        = var.kubernetes_version
}

data "aws_route53_zone" "default_domain" {
  name = var.route_53_zone
}

module "acm_request_certificate" {
  source                            = "cloudposse/acm-request-certificate/aws"
  version                           = "0.15.1"
  domain_name                       = var.route_53_zone
  process_domain_validation_options = true
  ttl                               = "300"
  subject_alternative_names         = ["*.${var.route_53_zone}"]
  depends_on                        = [data.aws_route53_zone.default_domain]
}

module "ingress" {
  source               = "git::https://github.com/sourcefuse/terraform-aws-ref-arch-eks//ingress?ref=4.0.1"
  certificate_arn      = module.acm_request_certificate.arn
  cluster_name         = module.eks_cluster.eks_cluster_id
  health_check_domains = var.health_check_domains
  route_53_zone_id     = data.aws_route53_zone.default_domain.zone_id
  helm_chart_version   = "4.6.0"
}

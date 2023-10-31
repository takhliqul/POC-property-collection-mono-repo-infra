health_check_domains              = ["healthcheck.property-collection"]
region                            = "eu-west-2"
environment                       = "dev"
namespace                         = "pc"
route_53_zone                     = "property-collection"
availability_zones                = ["eu-west-2a", "eu-west-2b"]
name                              = "pc-dev"
kubernetes_version                = "1.21" // TODO: update me
oidc_provider_enabled             = true
enabled_cluster_log_types         = ["audit"]
cluster_log_retention_period      = 7
instance_types                    = ["t3.medium"]
desired_size                      = 3
max_size                          = 25
min_size                          = 3
disk_size                         = 50
kubernetes_labels                 = {}
cluster_encryption_config_enabled = true
addons = [
  {
    addon_name = "vpc-cni"
    #    addon_version            = "v1.9.1-eksbuild.1"
    addon_version            = null
    resolve_conflicts        = "NONE"
    service_account_role_arn = null
  }
]
kubernetes_namespace =  "pc"
// TODO: tighten RBAC
#map_additional_iam_roles = [
#  {
#    username = "admin",
#    groups   = ["system:masters"],
#    rolearn  = "arn:aws:iam::757583164619:role/sourcefuse-poc-2-admin-role"
#  }
#] // TODO: update me
vpc_name = "pc-dev-vpc" // TODO: update me
private_subnet_names = [
  "pc-dev-private-eu-west-2a",
  "pc-dev-private-eu-west-2b"
]
public_subnet_names = [
  "pc-dev-public-eu-west-2a",
  "pc-dev-public-eu-west-2b"
]

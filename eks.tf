module "eks-cluster" {
  source = "terraform-aws-modules/eks/aws"
  #  version                       = "17.1.0"
  cluster_name    = "eks-task"
  cluster_version = "1.28"
  subnets         = flatten([module.vpc.public_subnets, module.vpc.private_subnets])
  #  cluster_delete_timeout        = "30m"
  cluster_iam_role_name     = "eks-task-cluster-iam-role"
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  #  cluster_log_retention_in_days = 7

  vpc_id = module.vpc.vpc_id

  fargate_pod_execution_role_name = "eks-task-pod-execution-role"
  fargate_profiles = {
    coredns-fargate-profile = {
      name = "coredns"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        },
        {
          namespace = "default"
        }
      ]
      subnets = flatten([module.vpc.private_subnets])
    }
  }
}

# resource "aws_eks_addon" "coredns" {
#   addon_name        = "coredns"
#   addon_version     = "v1.8.4-eksbuild.1"
#   cluster_name      = "eks-serve"
#   resolve_conflicts = "OVERWRITE"
#   depends_on        = [module.eks-cluster]
# }

data "aws_eks_cluster" "cluster" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  # load_config_file       = false
  # version                = "~> 1.9"
}

module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v18.26.5"
  cluster_name = local.cluster_name
  vpc_id       = "vpc-0578c27727ece7c56"
  subnet_ids   = ["subnet-0028f4b29db1925fa", "subnet-00d0c7cb1bcb321d1", "subnet-03a140caebb24ca2a"]

  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # cluster_encryption_config = [{
  #   provider_key_arn = "arn:aws:iam::951139900636:role/eksClusterRole"
  #   resources        = ["secrets"]
  # }]

  eks_managed_node_groups  = {
    default_node_group  = {
      desired_capacity = 3
      max_capacity     = 3
      min_capaicty     = 3

      instance_type = "t2.small"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = false
}
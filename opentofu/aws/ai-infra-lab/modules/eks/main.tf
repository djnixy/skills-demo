variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    general = {
      instance_types = ["t3.medium"]
      min_size     = 1
      max_size     = 3
      desired_capacity = 2
    }
    gpu = {
      instance_types = ["g4dn.xlarge"]
      min_size     = 1
      max_size     = 2
      desired_capacity = 1
      labels = {
        "compute-type" = "gpu"
      }
      taints = [
        {
          key    = "nvidia.com/gpu"
          value  = "true"
          effect = "NoSchedule"
        }
      ]
    }
  }
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  name    = var.project_name
  kubernetes_version = 1.36
  compute_config = {
    enabled = false # disable EKS auto mode
  }
  upgrade_policy = {
    support_type = "STANDARD" #STANDARD or EXTENDED
  }

  # Cluster Access Management
  authentication_mode                      = "API_AND_CONFIG_MAP"
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    admin_role = {
      principal_arn = "arn:aws:iam::939923956045:role/administrator-role"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:iam::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  # EKS Addons
  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    vpc-cni                = {
      most_recent = true
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets
  enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  eks_managed_node_groups = {
    bottle_rocket_default_groups = {
      create = true
      name = "BR_default_groups"
      use_name_prefix = false
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3a.medium"]
      capacity_type  = "SPOT" #Default: "ON_DEMAND"

      min_size = 1
      max_size = 5

      desired_size = 1

      # This is not required - demonstrates how to pass additional configuration
      # Ref https://bottlerocket.dev/en/os/1.19.x/api/settings/
      # bootstrap_extra_args = <<-EOT
      #   # The admin host container provides SSH access and runs with "superpowers".
      #   # It is disabled by default, but can be disabled explicitly.
      #   [settings.host-containers.admin]
      #   enabled = false

      #   # The control host container provides out-of-band access via SSM.
      #   # It is enabled by default, and can be disabled if you do not expect to use SSM.
      #   # This could leave you with no way to access the API and change settings on an existing node!
      #   [settings.host-containers.control]
      #   enabled = true

      #   # extra args added
      #   [settings.kernel]
      #   lockdown = "integrity"
      # EOT
      launch_template_name = "template-BR_default_groups"
      launch_template_use_name_prefix = false

      iam_role_attach_cni_policy = true
      iam_role_additional_policies = {
        AmazonEKS_CNI_Policy                = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        additional                         = aws_iam_policy.node_additional.arn
      }
    }
    bottle_rocket_api_groups = {
      create = true
      name = "BR_api_groups"
      use_name_prefix = false
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3a.medium"]
      capacity_type  = "SPOT" #Default: "ON_DEMAND"

      min_size = 1
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 1
      launch_template_name = "template-BR_api_groups"
      launch_template_use_name_prefix = false

      iam_role_attach_cni_policy = true
      iam_role_additional_policies = {
        AmazonEKS_CNI_Policy                = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        additional                         = aws_iam_policy.node_additional.arn
      }
    }
  }

  create_iam_role          = true
  iam_role_name            = "${var.project_name}-cluster-role"
  iam_role_use_name_prefix = false
  iam_role_description     = "EKS Cluster IAM role"
}



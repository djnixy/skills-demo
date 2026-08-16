module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.25.0"

  name               = var.project_name
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

  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]

  access_entries = {
    # current_caller = {
    #   principal_arn = data.aws_caller_identity.current.arn
    #   policy_associations = {
    #     admin = {
    #       policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    #       access_scope = {
    #         type = "cluster"
    #       }
    #     }
    #   }
    # }
    admin_role = {
      principal_arn = "arn:aws:iam::939923956045:role/administrator-role"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
    additional_user = {
      principal_arn = "arn:aws:sts::939923956045:assumed-role/administrator-role/admin@nikiakbaroutlookcom.onmicrosoft.com"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
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
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    kube-proxy = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    eks-pod-identity-agent = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    aws-efs-csi-driver = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    aws-ebs-csi-driver = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    aws-secrets-store-csi-driver-provider = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    external-dns = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    cert-manager = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    metrics-server = {
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
    }
    vpc-cni = {
      before_compute              = true
      most_recent                 = true
      resolve_conflicts_on_create = "OVERWRITE"
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
  }

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnets
  enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  eks_managed_node_groups = {
    bottle_rocket_default_groups = {
      create          = true
      name            = "BR_default_medium"
      use_name_prefix = false
      ami_type        = "BOTTLEROCKET_x86_64"
      instance_types  = ["t3a.medium"]
      capacity_type   = "SPOT" #Default: "ON_DEMAND"

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
      launch_template_name            = "template-BR_default_medium"
      launch_template_use_name_prefix = false

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
      }

      iam_role_attach_cni_policy = true
      iam_role_additional_policies = {
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEFSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        additional                         = aws_iam_policy.node_additional.arn
      }
    }

    bottle_rocket_api_groups = {
      create          = true
      name            = "BR_api_medium"
      use_name_prefix = false
      ami_type        = "BOTTLEROCKET_x86_64"
      instance_types  = ["t3a.micro"]
      capacity_type   = "SPOT" #Default: "ON_DEMAND"

      min_size = 1
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size                    = 1
      launch_template_name            = "template-BR_api_medium"
      launch_template_use_name_prefix = false

      labels = {
        workload = "api"
      }

      taints = {
        dedicated = {
          key    = "workload"
          value  = "api"
          effect = "NO_SCHEDULE"
        }
      }

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
      }

      iam_role_attach_cni_policy = true
      iam_role_additional_policies = {
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEFSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
        AmazonEBSCSIDriverPolicy           = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        additional                         = aws_iam_policy.node_additional.arn
      }
    }
  }

  create_iam_role          = true
  iam_role_name            = "${var.project_name}-cluster-role"
  iam_role_use_name_prefix = false
  iam_role_description     = "EKS Cluster IAM role"
}


resource "terraform_data" "kubeconfig" {
  depends_on = [module.eks.cluster_name]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.deploy_region}"
  }
}
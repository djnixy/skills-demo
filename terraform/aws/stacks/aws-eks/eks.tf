module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.22.0"

  cluster_name    = var.product_name
  cluster_upgrade_policy = {
    support_type = "STANDARD"
  }

  # EKS Addons
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    eks-pod-identity-agent = {}
    vpc-cni                = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  eks_managed_node_groups = {
    bottle_rocket_default_groups = {
      create = true
      name = "BR_default_groups"
      use_name_prefix = false
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3a.micro"]
      capacity_type  = "SPOT" #Default: "ON_DEMAND"

      min_size = 1
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
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
    }
    bottle_rocket_api_groups = {
      create = true
      name = "BR_api_groups"
      use_name_prefix = false
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3a.micro"]
      capacity_type  = "SPOT" #Default: "ON_DEMAND"

      min_size = 1
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 1
      launch_template_name = "template-BR_api_groups"
      launch_template_use_name_prefix = false
    }
  }

  create_iam_role          = true
  iam_role_name            = "eks-managed-node-group-complete-example"
  iam_role_use_name_prefix = false
  iam_role_description     = "EKS managed node group complete example role"
  iam_role_tags = {
    Purpose = "Protector of the kubelet"
  }

  iam_role_additional_policies = {
    AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    additional                         = aws_iam_policy.node_additional.arn
  }

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::939923956045:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::939923956045:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::939923956045:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]

  aws_auth_accounts = [
    "939923956045"
  ]

}



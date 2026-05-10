
resource "aws_iam_policy" "additional" {
  name = "${var.product_name}-additional"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_security_group" "remote_access" {
  name   = "remote-access"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Modify as per your security requirements
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = <<EOF
#     - rolearn: arn:aws:iam::939923956045:role/administrator-role
#       username: eks_administrator
#       groups:
#         - system:masters
#     EOF
#   }
# }

# resource "aws_iam_role" "eks_user" {
#   name = "eks_user"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Principal = {
#         Service = "eks.amazonaws.com"
#       }
#       Effect = "Allow"
#       Sid    = ""
#     }]
#   })
# }

# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = <<EOF
#     - rolearn: ${aws_iam_role.eks_user.arn}
#       username: eks_administrator
#       groups:
#         - system:masters
#     EOF
#   }
# }


resource "aws_iam_policy" "node_additional" {
  name        = "node-additional"
  description = "Additional policy for nodes"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["ec2:Describe*"]
        Resource = "*"
      }
    ]
  })
}



module "alb-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  vpc_id = var.vpc_id
  name   = local.alb_sg_name
  use_name_prefix = false
  description = "Security group with HTTP and HTTPS ports open for public (IPv4 CIDR)"


  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["http-80-tcp", "https-443-tcp"]

  egress_rules      = ["all-all"]
}

module "ecs-frontend-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  vpc_id = var.vpc_id
  name   = local.ecs_sg_frontend_name
  use_name_prefix = false
  description = "Security group with HTTP port open to Application Load Balancer"
  egress_rules      = ["all-all"]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules = ["http-80-tcp", "https-443-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb-sg.security_group_id
    }
  ]
}

module "ecs-backend-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.16.2"

  vpc_id = var.vpc_id
  name   = local.ecs_sg_backend_name
  use_name_prefix = false
  description = "Security group with HTTP port open to Application Load Balancer"
  egress_rules      = ["all-all"]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  # ingress_rules = ["http-80-tcp", "https-443-tcp"]
  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb-sg.security_group_id
    }
  ]
}


# module "rds-sg" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "4.16.2"

#   vpc_id = var.vpc_id
#   name   = local.rds_sg_name
#   use_name_prefix = false
#   description = "Security group with MySQL ports open ECS instance"

#   egress_rules      = ["all-all"]
#   ingress_cidr_blocks = ["0.0.0.0/0"]
#   ingress_rules = ["mysql-tcp"]
  
# }
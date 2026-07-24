module "vpc" {
  source = "../../modules/vpc"
  # Prod would use a different CIDR to avoid overlapping with sandbox
  vpc_cidr = "10.1.0.0/16"
}

module "aws_resources" {
  source       = "../../modules/aws"
  bucket_name  = "prod-ai-docs-niki"
  queue_name   = "prod-ai-processing-queue-niki"
}

module "eks" {
  source       = "../../modules/eks"
  cluster_name = "prod-ai-infra-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
}

module "dns_setup" {
  source       = "../../modules/cloudflare"
  zone_id      = "9a15d4f64f06265a9e083210a1cfdf11"
  record_name  = "ai-prod"
  record_value = module.eks.cluster_endpoint
}

module "vpc" {
  source = "../../modules/vpc"
}

module "aws_resources" {
  source       = "../../modules/aws"
  bucket_name  = "production-ai-docs-niki"
  queue_name   = "production-ai-processing-queue-niki"
}

module "eks" {
  source       = "../../modules/eks"
  cluster_name = "ai-infra-cluster"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnets
}

module "dns_setup" {
  source       = "../../modules/cloudflare"
  zone_id      = "9a15d4f64f06265a9e083210a1cfdf11"
  record_name  = "ai"
  record_value = module.eks.cluster_endpoint
}

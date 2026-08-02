data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host =  module.eks.cluster_endpoint
  token                  = module.eks.token
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    # aws_eks_cluster.my-cluster.certificate_authority.0.data)
}
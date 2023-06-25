provider "aws" {
  region = "us-east-1" # substitua pela sua região
}

data "aws_eks_cluster" "cluster" {
  name = "my-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = "my-cluster"
}

data "aws_availability_zones" "available" {}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
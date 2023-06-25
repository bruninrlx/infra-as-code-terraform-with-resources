data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ecr_policy"
  description = "Permit access to ECR"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = module.eks.worker_iam_role_name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.1.0"

  cluster_name     = "my-cluster"
  cluster_version  = "1.20"
  subnets          = concat(data.terraform_remote_state.vpc.outputs.private_subnets, data.terraform_remote_state.vpc.outputs.public_subnets)
  vpc_id           = data.terraform_remote_state.vpc.outputs.vpc_id

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 10
      min_capacity     = 1
      instance_type    = "m4.large"
      key_name         = "my-key-name"

      additional_tags = {
        Environment = "test"
        Name        = "eks_nodes"
      }
    }
  }
}

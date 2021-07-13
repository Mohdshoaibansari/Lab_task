provider "aws" {
  region = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket = "deletable-vasu-awss-4634-artifacts"
    key    = "crp/terraform"
    region = "eu-central-1"
  }
}

resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-service-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}

###############Cluster ###############
resource "aws_eks_cluster" "eks-cluster-test" {
  name     = "eks-cluster-test"
  role_arn = aws_iam_role.eks-cluster-role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    #aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]
}



resource "aws_iam_role" "cluster" {
  count                 = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  # name                  = "${var.cluster_name}-${data.aws_caller_identity.current.account_id}-cluster-role"
  name                  = var.cluster_name
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  permissions_boundary  = var.permissions_boundary
  path                  = var.iam_path
  force_detach_policies = true
  tags                  = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  count      = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = local.cluster_iam_role_name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  count      = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = local.cluster_iam_role_name
}

/*
 Adding a policy to cluster IAM role that allow permissions
 required to create AWSServiceRoleForElasticLoadBalancing service-linked role by EKS during ELB provisioning
*/

data "aws_iam_policy_document" "cluster_elb_sl_role_creation" {
  count = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeInternetGateways"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "cluster_elb_sl_role_creation" {
  count       = var.manage_cluster_iam_resources && var.create_eks ? 1 : 0
  name = "${var.cluster_name}-elb-sl-role-creation"
  role        = local.cluster_iam_role_name
  policy      = data.aws_iam_policy_document.cluster_elb_sl_role_creation[0].json
}

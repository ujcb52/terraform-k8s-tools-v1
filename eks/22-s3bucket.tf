resource "aws_s3_bucket" "chartmuseum" {
  bucket = "${var.cluster_name}-chartmuseum"
  acl    = "private"

  force_destroy = true

  tags = {
    "Name"                                = "${var.cluster_name}-chartmuseum"
    "KubernetesCluster"                   = var.cluster_name
    "kubernetes.io/cluster/${local.name}" = "owned"
  }

}
# region = "ap-northeat-2"

module "eks_fargate" {
  source  = "terraform-module/eks-fargate-profile/aws"
  version = "2.2.0"

  cluster_name         = "jtools-v1"
  subnet_ids           = ["subnet-00a56631a55b3c83a", "subnet-08732a9800b78a615"]
  namespaces           = ["default"]
  labels = {
    "app.kubernetes.io/name" = "default-service"
    }
    tags = {
    "ENV" = "dev"
    }

}

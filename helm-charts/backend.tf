terraform {
  backend "s3" {
    region         = "ap-northeast-2"
    bucket         = "terraform-k8s-jwtools-state"
    key            = "helm-charts-v1.tfstate"
  }
  required_version = ">= 0.12"
}

variable "region" {
  description = "생성될 리전을 입력 합니다. e.g: ap-northeast-2"
  default     = "ap-northeast-2"
}

variable "cluster_name" {
  description = "EKS Cluster 이름을 입력합니다. e.g: eks-demo"
  default     = "jtools-v1"
}

variable "cluster_role" {
  description = "EKS Cluster 롤을 입력합니다. e.g: dev, stg, prod, devops"
  default     = "devops"
}

variable "admin_username" {
  default = "admin"
}

variable "admin_password" {
  default = "password"
}

variable "root_domain" {
  default = "k8s.jwdevtools.cf"
}

variable "base_domain" {
  default = "tools.k8s.jwdevtools.cf"
}

variable "slack_token" {
  default = "SLACK_TOKEN"
}


variable "argocd_enabled" {
  default = true
}

variable "chartmuseum_enabled" {
  default = true
}

variable "registry_enabled" {
  default = true
}

variable "efs_id" {
#  default = "fs-5df6ff3c"
  default = "fs-154b5374"
}
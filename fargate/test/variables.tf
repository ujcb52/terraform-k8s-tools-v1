variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default = "jtools-v1"
}

variable "subnet_ids" {
  description = "Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile. These subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME (where CLUSTER_NAME is replaced with the name of the EKS Cluster)"
  type        = list(string)
  default     = ["subnet-00a56631a55b3c83a", "subnet-08732a9800b78a615"]
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `{ Deployed = \"xxxx\" }`"
}

variable "namespaces" {
  type        = list(string)
  description = "Kubernetes namespace(s) for selection.  Adding more than one namespace, creates and manages multiple namespaces."
  default     = ["default"]
}

variable "labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels for selection"
  default     = {}
}


variable "suffix" {
  type        = string
  description = "Suffix added to the name. In case we need more then one profile in same namespace"
  default     = ""
}

provider "aws" {
  region  = "ap-northeast-2"
}
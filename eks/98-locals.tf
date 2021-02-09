locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  name = "${var.cluster_name}"

  worker = "${local.name}-worker"

  workers = [
    "arn:aws:iam::${local.account_id}:role/${local.worker}",
  ]

  
}
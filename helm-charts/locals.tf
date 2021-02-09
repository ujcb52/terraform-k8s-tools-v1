locals {
  account_id = data.aws_caller_identity.current.account_id
}

locals {
  acm_arn  = "arn:aws:acm:ap-northeast-2:446804614856:certificate/61006ff2-d2a4-410b-8cb1-b63fec8e8ff8"
  acm_root = "k8s.jwdevtools.cf"
  acm_base = "scdf.k8s.jwdevtools.cf"

  host_name = local.acm_arn != "" ? "*.${local.acm_base}" : "*.${var.base_domain}"

  storage_class = var.efs_id == "" ? "default" : "efs"

  slack_url = format("%s/%s", "https://hooks.slack.com/services", var.slack_token)
}


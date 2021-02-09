data "aws_caller_identity" "current" {
}

locals {
  auth_launch_template_worker_roles = [
    for index in range(0, var.create_eks ? local.worker_group_launch_template_count : 0) : {
      worker_role_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${element(
        coalescelist(
          aws_iam_instance_profile.workers_launch_template.*.role,
          data.aws_iam_instance_profile.custom_worker_group_launch_template_iam_instance_profile.*.role_name,
          [""]
        ),
        index
      )}"
      platform = lookup(
        var.worker_groups_launch_template[index],
        "platform",
        local.workers_group_defaults["platform"]
      )
    }
  ]

  auth_worker_roles = [
    for index in range(0, var.create_eks ? local.worker_group_count : 0) : {
      worker_role_arn = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/${element(
        coalescelist(
          aws_iam_instance_profile.workers.*.role,
          data.aws_iam_instance_profile.custom_worker_group_iam_instance_profile.*.role_name,
          [""]
        ),
        index,
      )}"
      platform = lookup(
        var.worker_groups[index],
        "platform",
        local.workers_group_defaults["platform"]
      )
    }
  ]

  # Convert to format needed by aws-auth ConfigMap
  configmap_roles = [
    for role in concat(
      local.auth_launch_template_worker_roles,
      local.auth_worker_roles,
      # module.node_groups.aws_auth_roles,
    ) :
    {
      # Work around https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/153
      # Strip the leading slash off so that Terraform doesn't think it's a regex
      rolearn  = replace(role["worker_role_arn"], replace(var.iam_path, "/^//", ""), "")
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = tolist(concat(
        [
          "system:bootstrappers",
          "system:nodes",
        ],
        role["platform"] == "windows" ? ["eks:kube-proxy-windows"] : []
      ))
    }
  ]

  configmap_roles_adfs = [
    for role_name in var.adfs_role_names :
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWS-${data.aws_caller_identity.current.account_id}-${role_name["name"]}"
      username = "${data.aws_iam_account_alias.current.account_alias}-${role_name["name"]}"
      groups   = role_name["groups"]
    }
  ]
}

resource "kubernetes_config_map" "aws_auth" {
  count      = var.create_eks && var.manage_aws_auth ? 1 : 0
  depends_on = [null_resource.wait_for_cluster[0]]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.configmap_roles,
        local.configmap_roles_adfs,
        var.map_roles,
      ))
    )
    mapUsers    = yamlencode(var.map_users)
    mapAccounts = yamlencode(var.map_accounts)
  }
}

resource "helm_release" "cluster-autoscaler" {
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler-chart"
  version    = var.autoscaler_cluster_autoscaler_chart

  namespace = "kube-system"
  name      = "cluster-autoscaler"

  values = [
    file("./values/kube-system/cluster-autoscaler.yaml")
  ]

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  wait = false
}

# resource "helm_release" "efs-provisioner" {
#   repository = "https://kubernetes-charts.storage.googleapis.com"
#   chart      = "efs-provisioner"
#   version    = var.stable_efs_provisioner

#   namespace = "kube-system"
#   name      = "efs-provisioner"

#   values = [
#     file("./values/kube-system/efs-provisioner.yaml")
#   ]

#   set {
#     name  = "efsProvisioner.awsRegion"
#     value = var.region
#   }

#   set {
#     name  = "efsProvisioner.efsFileSystemId"
#     value = var.efs_id
#   }
# }

resource "helm_release" "k8s-spot-termination-handler" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "k8s-spot-termination-handler"
  version    = var.stable_k8s_spot_termination_handler

  namespace = "kube-system"
  name      = "k8s-spot-termination-handler"

  values = [
    file("./values/kube-system/k8s-spot-termination-handler.yaml")
  ]

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "slackUrl"
    value = local.slack_url
  }

  wait = false
}



resource "helm_release" "kube2iam" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "kube2iam"
  version    = var.stable_kube2iam

  namespace = "kube-system"
  name      = "kube2iam"

  values = [
    file("./values/kube-system/kube2iam.yaml")
  ]

  set {
    name  = "awsRegion"
    value = var.region
  }

  wait = false
}

resource "helm_release" "metrics-server" {
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "metrics-server"
  version    = var.stable_metrics_server

  namespace = "kube-system"
  name      = "metrics-server"

  values = [
    file("./values/kube-system/metrics-server.yaml")
  ]

  wait = false
}
resource "kubernetes_namespace" "devops" {
  count = var.cluster_role == "devops" ? 1 : 0

  metadata {
    name = "devops"
  }
}



resource "helm_release" "argocd" {
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argo_argo_cd

  namespace = "devops"
  name      = "argocd"

  values = [
    file("./values/devops/argocd.yaml")
  ]

  wait = false

  create_namespace = true

}


resource "helm_release" "chartmuseum" {
  count = var.cluster_role == "devops" ? var.chartmuseum_enabled ? 1 : 0 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "chartmuseum"
  version    = var.stable_chartmuseum

  namespace = "devops"
  name      = "chartmuseum"

  values = [
    file("./values/devops/chartmuseum.yaml")
  ]

  # set {
  #   name  = "env.open.STORAGE_AMAZON_BUCKET"
  #   value = "${var.cluster_name}-chartmuseum"
  # }

  # set {
  #   name  = "env.open.STORAGE_AMAZON_REGION"
  #   value = var.region
  # }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    # helm_release.efs-provisioner,
  ]
}

resource "helm_release" "docker-registry" {
  count = var.cluster_role == "devops" ? var.registry_enabled ? 1 : 0 : 0

  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "docker-registry"
  version    = var.stable_docker_registry

  namespace = "devops"
  name      = "docker-registry"

  values = [
    file("./values/devops/docker-registry.yaml")
  ]

  # set {
  #   name  = "s3.bucket"
  #   value = "${var.cluster_name}-chartmuseum-${local.account_id}"
  # }

  # set {
  #   name  = "s3.region"
  #   value = var.region
  # }

  wait = false

  depends_on = [
    kubernetes_namespace.devops,
    # helm_release.efs-provisioner,
  ]
}
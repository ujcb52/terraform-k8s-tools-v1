
# resource "helm_release" "ingress-nginx" {
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"
#   version    = var.ingress_nginx_ingress_nginx

#   namespace = "kube-ingress"
#   name      = "ingress-nginx"

#   values = [
#     file("./values/kube-ingress/ingress-nginx.yaml")
#   ]

#   wait = false

#   create_namespace = true

#   # depends_on = [
#   #   # helm_release.prometheus-operator,
#   # ]
# }

resource "helm_release" "external-dns" {
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = var.bitnami_external_dns

  namespace = "kube-ingress"
  name      = "external-dns"

  values = [
    file("./values/kube-ingress/external-dns.yaml")
  ]

  wait = false

  create_namespace = true
}


resource "kubernetes_manifest" "scaled_deployment" {
  provider = kubernetes-alpha
  manifest = local.manifest
}
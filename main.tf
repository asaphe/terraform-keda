resource "kubernetes_manifest" "scaled_deployment" {
  manifest = {
    "apiVersion" = "keda.sh/v1alpha1"
    "kind"       = "ScaledObject"

    "metadata" = {
      "name"      = var.scaled_object_name
      "namespace" = var.namespace

      "labels" = {
        "name" = var.scaled_object_name
      }
    }

    "spec" = {
      "cooldownPeriod"  = lookup(var.manifest, "cooldown_period", 300)
      "maxReplicaCount" = lookup(var.manifest, "max_replica_count") # Maximum number of replicas KEDA will scale the resource up to
      "minReplicaCount" = lookup(var.manifest, "min_replica_count") # Minimum number of replicas KEDA will scale the resource down to
      "pollingInterval" = lookup(var.manifest, "polling_interval", 30)

      "scaleTargetRef" = {
        "apiVersion" = "apps/v1"
        "kind"       = lookup(var.scale_target_refs, "kind")
        "name"       = lookup(var.scale_target_refs, "name")
      }

      "advanced" = var.advanced != null ? var.advanced : null
      "triggers" = [for map in var.triggers : map]
    }
  }
}

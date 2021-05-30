locals {
  manifest = {
    apiVersion = "keda.sh/v1alpha1"
    kind       = lookup(var.manifest, "kind", "ScaledObject")
    metadata = {
      "name" = var.scaled_object_name
      "namespace" = var.namespace
    }
    spec = {
      "scaleTargetRef" = {
        "apiVersion"             = lookup(var.scale_target_refs, "api_version", null)
        "kind"                   = lookup(var.scale_target_refs, "kind", null)
        "name"                   = lookup(var.scale_target_refs, "name", null)
        "envSourceContainerName" = lookup(var.scale_target_refs, "env_source_container_name", null)
      }
      "pollingInterval" = lookup(var.manifest, "polling_interval", 30)
      "cooldownPeriod"  = lookup(var.manifest, "cooldown_period", 300)
      "minReplicaCount" = lookup(var.manifest, "min_replica_count", 2)    # Minimum number of replicas KEDA will scale the resource down to
      "maxReplicaCount" = lookup(var.manifest, "max_replica_count", 100)  # Maximum number of replicas KEDA will scale the resource up to
      ## Optional section "advanced"
      advanced = var.advanced
      triggers = var.triggers
    }
  }
}
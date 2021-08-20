variable "namespace" {
  description = "(Required) Namespace for the scaledObject"
  type        = string
}

variable "scaled_object_name" {
  description = "(Required) scaledObject name"
  type        = string
}

variable "scale_target_refs" {
  description = "(Required) .spec.ScaleTargetRef section holds the reference to the target resource, ie. Deployment, StatefulSet or Custom Resource."
  type        = map(any)
}

variable "manifest" {
  description = "(Required) Object YAML"
  type        = map(any)

  validation {
    condition     = lookup(var.manifest, "max_replica_count") <= 200
    error_message = "Maximum number of pods to scale to cannot be larger than 200."
  }

  validation {
    condition     = lookup(var.manifest, "min_replica_count") != 0
    error_message = "Minimum number of pods cannot be 0. scale to zero is disabled."
  }
}

variable "advanced" {
  description = "(Optional) Section to specify advanced options"
  type        = any
  default     = null
}

variable "triggers" {
  description = "(Optional) Section to specify triggers"
  type        = any
  default     = null
}
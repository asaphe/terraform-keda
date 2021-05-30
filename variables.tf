variable "namespace" {
  description = "(Required) Namespace for the scaledObject"
  type        = string
  default     = ""
}

variable "scaled_object_name" {
  description = "scaledObject name"
  type        = string
  default     = ""
}

variable "scale_target_refs" {
  description = ".spec.ScaleTargetRef section holds the reference to the target resource, ie. Deployment, StatefulSet or Custom Resource."
  type        = map(any)
  default     = {}
}

variable "manifest" {
  description = "Object YAML"
  type        = map(any)
  default     = {}
}

variable "scaledown" {
  description = "HPA behavior when scaling down"
  type        = map(any)
  default     = {}
}

variable "scaleup" {
  description = "HPA behavior when scaling up"
  type        = map(any)
  default     = {}
}

variable "restore_original_replica_count" {
  description = "determines whether KEDA should reset the number of pods to the starting point when you delete this ScaledObject from your cluster"
  type        = bool
  default     = false
}

variable "advanced" {
  description = "Section to specify advanced options"
  type        = any # map(map(any)) cannot work since we have a string too. map(any) fails
  default     = {}
}

variable "triggers" {
  description = "Section to specify triggers"
  type        = any # list(any) or list(map) fails
  default     = []
}
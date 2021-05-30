# Keda

This module should run as part of a deployment to ensure a scaledobject has been created.

## Version

* developed using Terraform 15.1
* using the Kubernetes Alpha provider
  > The provider is not production ready

### Kubernetes alpha provider requirements

* Terraform version 0.14.8+
* Kubernetes version 1.17.x +

## Supports

* scaledObject for a deployment
  > Job is not supported at this time

## Examples (Final YAML version)

* [Provider Docs](https://github.com/hashicorp/terraform-provider-kubernetes-alpha)

A scaled object based on Kafka lag and CPU utilization (advanced behavior is set to match the application requirements)

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: test
  namespace: default
  labels:
    name: test-scaledobject
spec:
  scaleTargetRef:
    kind: Deployment
    name: router
  pollingInterval: 30
  cooldownPeriod: 300 # only relevant if min replicas is 0
  minReplicaCount: 2
  maxReplicaCount: 8
  advanced:
    restoreToOriginalReplicaCount: true
    horizontalPodAutoscalerConfig:
      behavior:
        scaleDown:
          stabilizationWindowSeconds: 900 # consider past 15min
          policies:
          - type: Percent
            value: 50
            periodSeconds: 60
          - type: Pods
            value: 2
            periodSeconds: 60
          selectPolicy: Min
  triggers:
  - type: kafka
    metadata:
      bootstrapServers: kafka.dev.domain.com:9092
      consumerGroup: test_app
      topic: test_1
      lagThreshold: "10000"
  - type: cpu
    metadata:
      type: Utilization
      value: "95"
```

A scaled object based on a Prometheus metric (notice the query uses `sum`)

```yaml
apiVersion: keda.k8s.io/v1alpha1
kind: ScaledObject
metadata:
  name: keda-test-scaledobject
  namespace: default
spec:
  scaleTargetRef:
    deploymentName: test-deployment
  triggers:
  - type: prometheus
    metadata:
      serverAddress: http://prometheus.svc:9090
      metricName: custom_metric_counter_total_by_pod
      threshold: '3'
      query: sum(custom_metric_counter_total_by_pod{namespace!="",pod!=""})
```

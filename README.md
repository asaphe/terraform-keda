# Keda

This module should run as part of a deployment to ensure a scaledobject has been created.

## Version

* Terraform version 1.0.0
* Kubernetes provider - enable experimental manifest

## Supports

* scaledObject for a deployment
  > **Job is not supported at this time**

## Examples (Final YAML version)

A scaled object based on Kafka lag and CPU utilization (advanced behavior is set to match the application requirements)

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: router
  namespace: default
  labels:
    name: router-scaledobject
spec:
  scaleTargetRef:
    kind: Deployment
    name: router
  pollingInterval: 30
  cooldownPeriod: 300
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
      bootstrapServers: kafka-brokers.dev.example.com:9092
      consumerGroup: router_app
      topic: router_2
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
    deploymentName: kedademo
  triggers:
  - type: prometheus
    metadata:
      serverAddress: http://prometheus.svc:9090
      metricName: custom_metric_counter_total_by_pod
      threshold: '3'
      query: sum(custom_metric_counter_total_by_pod{namespace!="",pod!=""})
```

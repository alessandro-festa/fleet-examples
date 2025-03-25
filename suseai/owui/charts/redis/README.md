# Redis Helm Chart

> [Redis](https://redis.io) is an open source, in-memory data structure store, used as a database, cache, and message broker.

## Introduction

This Helm chart bootstraps an [Redis](https://redis.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Quick Start

```console
helm install my-release oci://dp.apps.rancher.io/charts/redis
```

### Prerequisites

* Helm 3.8.0 or later.
* Kubernetes 1.24 or later.
* PV provisioner support in the underlying infrastructure.

## Install Chart

To install the Helm chart with the release name *my-release*:

```console
helm install my-release \
    --set 'global.imagePullSecrets[0].name'=my-pull-secrets \
    oci://dp.apps.rancher.io/charts/redis \
```

This deploys the application to the Kubernetes cluster using the default configuration provided by the Helm chart.

> NOTE: You can follow [these steps](https://cloud.google.com/artifact-registry/docs/access-control#pullsecrets)
> to create and setup the image pull secrets, if you don't have them already.

## Uninstall Chart

To uninstall the Helm chart with the release name *my-release*:

```console
helm uninstall my-release
```

This removes all the Kubernetes components associated to the Helm chart

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| appendOnlyFile | bool | `true` | Whether to enable Append Only File (AOF) mode See: https://redis.io/docs/management/config-file/ |
| architecture | string | `"standalone"` | Redis architecture to deploy. Valid values: standalone, sentinel, cluster |
| auth.enabled | bool | `true` | Enable Redis password authentication |
| auth.existingSecret | string | `""` | Name of a secret containing the Redis password (if set, `auth.password` will be ignored) |
| auth.password | string | `""` | Redis password |
| auth.passwordKey | string | `""` | Password key in the secret @default `password` |
| cluster.configurationFile | string | `"nodes.conf"` | Redis Cluster configuration file name in the volume |
| cluster.replicasPerMaster | int | `0` | Amount of replicas per master node that will be configured in the cluster. It must satisfy this rule: `nodeCount = masterCount + (masterCount * replicasPerMaster)`. Or alternatively: `replicasPerMaster = (nodeCount - masterCount) / masterCount`. And all valuest must be whole numbers. For example, for 6 nodes, if you want 3 masters, then the nodeCount value (number of replicas per master) must be set to 1. |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |
| commonAnnotations | object | `{}` | Annotations to add to all deployed objects |
| commonLabels | object | `{}` | Labels to add to all deployed objects |
| configMap | object | See `values.yaml` | ConfigMaps to deploy |
| configMap.* | string | `nil` | Custom configuration file to include, templates are allowed both in the config map name and contents |
| configMap.enabled | bool | `true` | Create a config map for Redis configuration |
| configuration | string | `""` | Extra configurations to add to the Redis configuration file. Can be defined as a string, a key-value map, or an array of entries. See: https://redis.io/docs/management/config-file/ |
| configurationFile | string | `"redis.conf"` | Configuration file name in the config map |
| containerPorts.* | int32 | `nil` | Custom port number to expose in the Redis containers |
| containerPorts.metrics | int32 | `9121` | Port number where metrics will be exposed to |
| containerPorts.redis | int32 | `6379` | Redis port number for client connections |
| containerPorts.sentinel | int32 | `26379` | Redis Sentinel port number |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Allow privilege escalation within containers |
| containerSecurityContext.enabled | bool | `true` | Enable container security context |
| containerSecurityContext.runAsNonRoot | bool | `true` | Run containers as a non-root user |
| containerSecurityContext.runAsUser | int | `1000` | Which user ID to run the container as |
| disableCommands | list | `["FLUSHALL","FLUSHDB"]` | List of Redis commands to disable |
| existingConfigMap | string | `""` | Name of an existing config map for extra configurations to add to the Redis configuration file |
| extraManifests | list | `[]` | Additional Kubernetes manifests to include in the chart |
| fullnameOverride | string | `""` | Override the resource name |
| global.imagePullSecrets | list | `[]` | Global override for container image registry pull secrets |
| global.imageRegistry | string | `""` | Global override for container image registry |
| global.storageClassName | string | `""` | Global override for the storage class |
| headlessService.* | string | `nil` | Custom attributes for the Redis headless service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| headlessService.annotations | object | `{}` | Custom annotations to add to the headless service for Redis |
| headlessService.clusterIP | string | `"None"` |  |
| headlessService.ports.* | int32 | `nil` | Headless service port override for custom Redis ports specified in `containerPorts.*` |
| headlessService.ports.redis | int32 | `""` | Headless service port override for Redis client connections |
| headlessService.publishNotReadyAddresses | bool | `true` | Disregard indications of ready/not-ready The primary use case for setting this field is for a StatefulSet's Headless Service to propagate SRV DNS records for its Pods for the purpose of peer discovery |
| headlessService.type | string | `"ClusterIP"` | Redis headless service type |
| images.metrics.digest | string | `""` | Image digest to use for the Redis container (if set, `images.redis.tag` will be ignored) |
| images.metrics.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the Redis container |
| images.metrics.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the Redis Exporter container |
| images.metrics.repository | string | `"containers/redis-exporter"` | Image repository to use for the Redis Exporter container |
| images.metrics.tag | string | `"1"` | Image tag to use for the Redis container |
| images.redis.digest | string | `""` | Image digest to use for the Redis container (if set, `images.redis.tag` will be ignored) |
| images.redis.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the Redis container |
| images.redis.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the Redis container |
| images.redis.repository | string | `"containers/redis"` | Image repository to use for the Redis container |
| images.redis.tag | string | `"7.4.2"` | Image tag to use for the Redis container |
| images.sentinel.digest | string | `""` | Image digest to use for the Redis Sentinel container (if set, `images.sentinel.tag` will be ignored) |
| images.sentinel.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the Redis Sentinel container |
| images.sentinel.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the Redis Sentinel container |
| images.sentinel.repository | string | `"containers/redis"` | Image repository to use for the Redis Sentinel container |
| images.sentinel.tag | string | `"7.4.2"` | Image tag to use for the Redis Sentinel container |
| images.volume-permissions.digest | string | `""` | Image digest to use for the volume permissions init container (if set, `images.volume-permissions.tag` will be ignored) |
| images.volume-permissions.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the volume-permissions container |
| images.volume-permissions.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the volume permissions init container |
| images.volume-permissions.repository | string | `"containers/bci-busybox"` | Image repository to use for the volume permissions init container |
| images.volume-permissions.tag | string | `"15.6"` | Image tag to use for the volume permissions init container |
| metrics.annotations | object | See `values.yaml` | Annotations to add to all pods that expose metrics |
| metrics.enabled | bool | `false` | Expose Redis metrics |
| metrics.prometheusRule.configuration | object | `{}` | Content of the Prometheus rule file See https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/ |
| metrics.prometheusRule.enabled | bool | `false` | Create a PrometheusRule resource (also requires `metrics.enabled` to be enabled) |
| metrics.prometheusRule.labels | object | `{}` | Additional labels that will be added to the PrometheusRule resource |
| metrics.prometheusRule.namespace | string | `""` | Namespace for the PrometheusRule resource (defaults to the release namespace) |
| metrics.service.* | string | `nil` | Custom attributes for the service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| metrics.service.annotations | object | `{}` | Custom annotations to add to the service for redis-exporter |
| metrics.service.enabled | bool | `true` | Create a service for redis-exporter (apart from the headless service) |
| metrics.service.nodePorts.* | int32 | `nil` | Service nodePort override for custom ports specified in `containerPorts.*` |
| metrics.service.nodePorts.metrics | int32 | `""` | Service nodePort override for redis-exporter metrics connections |
| metrics.service.ports.* | int32 | `nil` | Service port override for custom ports specified in `containerPorts.*` |
| metrics.service.ports.metrics | int32 | `""` | Service port override for redis-exporter metrics connections |
| metrics.service.type | string | `"ClusterIP"` | Service type |
| nameOverride | string | `""` | Override the resource name prefix (will keep the release name) |
| networkPolicy.allowExternalConnections | bool | `true` | Allow all external connections from and to the pods |
| networkPolicy.egress.allowExternalConnections | bool | `true` | Allow all external egress connections from the pods (requires also `networkPolicy.allowExternalConnections`) |
| networkPolicy.egress.enabled | bool | `true` | Create an egress network policy (requires also `networkPolicy.enabled`) |
| networkPolicy.egress.extraRules | list | `[]` | Custom additional egress rules to enable in the NetworkPolicy resource |
| networkPolicy.egress.namespaceLabels | object | `{}` | List of namespace labels for which to allow egress connections, when external connections are disallowed |
| networkPolicy.egress.podLabels | object | `{}` | List of pod labels for which to allow egress connections, when external connections are disallowed |
| networkPolicy.egress.ports.* | int32 | `nil` | Network policy port override for custom ports specified in `containerPorts.*` for egress connections |
| networkPolicy.egress.ports.client | int32 | `""` | Network policy port override for Redis client connections for egress connections |
| networkPolicy.egress.ports.peer | int32 | `""` | Network policy port override for Redis peer connections for egress connections |
| networkPolicy.enabled | bool | `false` | Create a NetworkPolicy resource |
| networkPolicy.ingress.allowExternalConnections | bool | `true` | Allow all external ingress connections to the pods (requires also `networkPolicy.allowExternalConnections`) |
| networkPolicy.ingress.enabled | bool | `true` | Create an ingress network policy (requires also `networkPolicy.enabled`) |
| networkPolicy.ingress.extraRules | list | `[]` | Custom additional ingress rules to enable in the NetworkPolicy resource |
| networkPolicy.ingress.namespaceLabels | object | `{}` | List of namespace labels for which to allow ingress connections, when external connections are disallowed |
| networkPolicy.ingress.podLabels | object | `{}` | List of pod labels for which to allow ingress connections, when external connections are disallowed |
| networkPolicy.ingress.ports.* | int32 | `nil` | Network policy port override for custom ports specified in `containerPorts.*` for ingress connections |
| networkPolicy.ingress.ports.client | int32 | `""` | Network policy port override for Redis client connections for ingress connections |
| networkPolicy.ingress.ports.peer | int32 | `""` | Network policy port override for Redis peer connections for ingress connections |
| nodeCount | int | `1` | Desired number of Redis nodes to deploy (counting the Redis master node) |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Persistent volume access modes |
| persistence.annotations | object | `{}` | Custom annotations to add to the persistent volume claims used by Redis pods |
| persistence.enabled | bool | `true` | Enable persistent volume claims for Redis pods |
| persistence.existingClaim | string | `""` | Name of an existing PersistentVolumeClaim to use by Redis pods |
| persistence.labels | object | `{}` | Custom labels to add to the persistent volume claims used by Redis pods |
| persistence.resources.requests.storage | string | `"8Gi"` | Size of the persistent volume claim to create for Redis pods |
| persistence.storageClassName | string | `""` | Storage class name to use for the Redis persistent volume claim |
| podDisruptionBudget.enabled | bool | `false` | Create a pod disruption budget |
| podDisruptionBudget.maxUnavailable | string | `""` | Number of pods from that can be unavailable after the eviction, this option is mutually exclusive with minAvailable |
| podDisruptionBudget.minAvailable | string | `""` | Number of pods from that set that must still be available after the eviction, this option is mutually exclusive with maxUnavailable |
| podSecurityContext.enabled | bool | `true` | Enable pod security context |
| podSecurityContext.fsGroup | int | `1000` | Group ID that will write to persistent volumes |
| podTemplates.* | string | `nil` | Custom attributes for the pods in the Redis PodTemplate (see [`PodSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec)) |
| podTemplates.annotations | object | See `values.yaml` | Annotations to add to all pods in the Redis StatefulSet's PodTemplate |
| podTemplates.containers | object | See `values.yaml` | Containers to deploy in the Redis PodTemplate Each field has the container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| podTemplates.containers.metrics.* | string | `nil` | Custom attributes for the redis-exporter container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| podTemplates.containers.metrics.args | list | `[]` | Arguments override for the redis-exporter container entrypoint |
| podTemplates.containers.metrics.command | string | `""` | Entrypoint override for the redis-exporter container |
| podTemplates.containers.metrics.enabled | string | Same value as `metrics.enabled` | Enable the redis-exporter container in the Redis PodTemplate |
| podTemplates.containers.metrics.env | object | See `values.yaml` | Object with the environment variables templates to use in the redis-exporter container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| podTemplates.containers.metrics.envFrom | list | `[]` | List of sources from which to populate environment variables to the redis-exporter container (e.g. a ConfigMaps or a Secret) |
| podTemplates.containers.metrics.image | string | `""` | Image override for the redis-exporter container (if set, `images.redis.{name,tag,digest}` values will be ignored for this container) |
| podTemplates.containers.metrics.imagePullPolicy | string | `""` | Image pull policy override for the redis-exporter container (if set `images.redis.pullPolicy` values will be ignored for this container) |
| podTemplates.containers.metrics.livenessProbe.enabled | bool | `true` | Enable liveness probe for redis-exporter |
| podTemplates.containers.metrics.livenessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the redis-exporter liveness probe to be considered failed after having succeeded |
| podTemplates.containers.metrics.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the redis-exporter container has started before liveness probes are initiated |
| podTemplates.containers.metrics.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the redis-exporter liveness probe |
| podTemplates.containers.metrics.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the redis-exporter liveness probe to be considered successful after having failed |
| podTemplates.containers.metrics.livenessProbe.tcpSocket | object | See `values.yaml` | Port number used to check if the redis-exporter service is alive |
| podTemplates.containers.metrics.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the redis-exporter liveness probe times out |
| podTemplates.containers.metrics.ports | object | `{}` | Ports override for the redis-exporter container (if set, `containerPorts.*` values will be ignored for this container) |
| podTemplates.containers.metrics.readinessProbe.enabled | bool | `true` | Enable readiness probe for redis-exporter |
| podTemplates.containers.metrics.readinessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the redis-exporter readiness probe to be considered failed after having succeeded |
| podTemplates.containers.metrics.readinessProbe.httpGet | object | See `values.yaml` | HTTP endpoint used to check if the redis-exporter service is ready |
| podTemplates.containers.metrics.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the redis-exporter container has started before readiness probes are initiated |
| podTemplates.containers.metrics.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the redis-exporter readiness probe |
| podTemplates.containers.metrics.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the redis-exporter readiness probe to be considered successful after having failed |
| podTemplates.containers.metrics.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the redis-exporter readiness probe times out |
| podTemplates.containers.metrics.resources | object | `{}` | Custom resource requirements for the redis-exporter container |
| podTemplates.containers.metrics.securityContext | object | `{}` | Security context override for the redis-exporter container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| podTemplates.containers.metrics.startupProbe.enabled | bool | `false` | Enable startup probe for redis-exporter |
| podTemplates.containers.metrics.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the redis-exporter startup probe to be considered failed after having succeeded |
| podTemplates.containers.metrics.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the redis-exporter container has started before startup probes are initiated |
| podTemplates.containers.metrics.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the redis-exporter startup probe |
| podTemplates.containers.metrics.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the redis-exporter startup probe to be considered successful after having failed |
| podTemplates.containers.metrics.startupProbe.tcpSocket | object | See `values.yaml` | Port number used to check if the redis-exporter service has been started |
| podTemplates.containers.metrics.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the redis-exporter startup probe times out |
| podTemplates.containers.metrics.volumeMounts | object | See `values.yaml` | Volume mount templates for the redis-exporter container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| podTemplates.containers.redis.* | string | `nil` | Custom attributes for the Redis container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| podTemplates.containers.redis.args | list | `[]` | Arguments override for the Redis container entrypoint |
| podTemplates.containers.redis.command | list | See `values.yaml` | Entrypoint override for the Redis container |
| podTemplates.containers.redis.enabled | bool | `true` | Enable the Redis container in the PodTemplate |
| podTemplates.containers.redis.env | object | See `values.yaml` | Object with the environment variables templates to use in the Redis container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| podTemplates.containers.redis.envFrom | list | `[]` | List of sources from which to populate environment variables to the Redis container (e.g. a ConfigMaps or a Secret) |
| podTemplates.containers.redis.image | string | `""` | Image override for the Redis container (if set, `images.redis.{name,tag,digest}` values will be ignored for this container) |
| podTemplates.containers.redis.imagePullPolicy | string | `""` | Image pull policy override for the Redis container (if set `images.redis.pullPolicy` values will be ignored for this container) |
| podTemplates.containers.redis.livenessProbe.enabled | bool | `true` | Enable liveness probe for Redis |
| podTemplates.containers.redis.livenessProbe.exec | object | See `values.yaml` | Command to execute for the Redis startup probe |
| podTemplates.containers.redis.livenessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Redis liveness probe to be considered failed after having succeeded |
| podTemplates.containers.redis.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the Redis container has started before liveness probes are initiated |
| podTemplates.containers.redis.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Redis liveness probe |
| podTemplates.containers.redis.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Redis liveness probe to be considered successful after having failed |
| podTemplates.containers.redis.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Redis liveness probe times out |
| podTemplates.containers.redis.ports | object | `{}` | Ports override for the Redis container (if set, `containerPorts.*` values will be ignored for this container) |
| podTemplates.containers.redis.readinessProbe.enabled | bool | `true` | Enable readiness probe for Redis |
| podTemplates.containers.redis.readinessProbe.exec | object | See `values.yaml` | Command to execute for the Redis startup probe |
| podTemplates.containers.redis.readinessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Redis readiness probe to be considered failed after having succeeded |
| podTemplates.containers.redis.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the Redis container has started before readiness probes are initiated |
| podTemplates.containers.redis.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Redis readiness probe |
| podTemplates.containers.redis.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Redis readiness probe to be considered successful after having failed |
| podTemplates.containers.redis.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Redis readiness probe times out |
| podTemplates.containers.redis.resources | object | `{}` | Custom resource requirements for the Redis container |
| podTemplates.containers.redis.securityContext | object | `{}` | Security context override for the Redis container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| podTemplates.containers.redis.startupProbe.enabled | bool | `false` | Enable startup probe for Redis |
| podTemplates.containers.redis.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the Redis startup probe to be considered failed after having succeeded |
| podTemplates.containers.redis.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the Redis container has started before startup probes are initiated |
| podTemplates.containers.redis.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Redis startup probe |
| podTemplates.containers.redis.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the Redis startup probe to be considered successful after having failed |
| podTemplates.containers.redis.startupProbe.tcpSocket | object | See `values.yaml` | Port number used to check if the Redis service is alive |
| podTemplates.containers.redis.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the Redis startup probe times out |
| podTemplates.containers.redis.volumeMounts | object | See `values.yaml` | Volume mount templates for the Redis container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| podTemplates.imagePullSecrets | list | `[]` | Custom pull secrets for the Redis container in the PodTemplate |
| podTemplates.initContainers | object | See `values.yaml` | Init containers to deploy in the Redis PodTemplate Each field has the init container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| podTemplates.initContainers.volume-permissions.* | string | `nil` | Custom attributes for the Redis volume-permissions init container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| podTemplates.initContainers.volume-permissions.args | list | `[]` | Arguments override for the Redis volume-permissions init container entrypoint |
| podTemplates.initContainers.volume-permissions.command | list | See `values.yaml` | Entrypoint override for the Redis volume-permissions container |
| podTemplates.initContainers.volume-permissions.enabled | bool | `false` | Enable the volume-permissions init container in the Redis PodTemplate |
| podTemplates.initContainers.volume-permissions.env | object | No environment variables are set | Object with the environment variables templates to use in the Redis volume-permissions init container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| podTemplates.initContainers.volume-permissions.envFrom | list | `[]` | List of sources from which to populate environment variables to the Redis volume-permissions init container (e.g. a ConfigMaps or a Secret) |
| podTemplates.initContainers.volume-permissions.image | string | `""` | Image override for the Redis volume-permissions init container (if set, `images.volume-permissions.{name,tag,digest}` values will be ignored for this container) |
| podTemplates.initContainers.volume-permissions.imagePullPolicy | string | `""` | Image pull policy override for the Redis volume-permissions init container (if set `images.volume-permissions.pullPolicy` values will be ignored for this container) |
| podTemplates.initContainers.volume-permissions.resources | object | `{}` | Redis init-containers resource requirements |
| podTemplates.initContainers.volume-permissions.securityContext | object | See `values.yaml` | Security context override for the Redis volume-permissions init container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| podTemplates.initContainers.volume-permissions.volumeMounts | object | See `values.yaml` | Custom volume mounts for the Redis volume-permissions init container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| podTemplates.labels | object | `{}` | Labels to add to all pods in the Redis StatefulSet's PodTemplate |
| podTemplates.securityContext | object | `{}` | Security context override for the pods in the Redis PodTemplate (if set, `podSecurityContext.*` values will be ignored) |
| podTemplates.serviceAccountName | string | `""` | Service account name override for the pods in the Redis PodTemplate (if set, `serviceAccount.name` will be ignored) |
| podTemplates.volumes | object | See `values.yaml` | Volume templates for the Redis PodTemplate, templates are allowed in all fields Each field has the volume name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| secret | object | See `values.yaml` | Secrets to deploy |
| secret.* | string | `nil` | Custom secret to include, templates are allowed both in the secret name and contents |
| secret.enabled | string | `true` if authentication is enabled without existing secret, `false` otherwise | Create a secret for Redis credentials |
| sentinel.configMap | object | See `values.yaml` | ConfigMaps to deploy for Sentinel |
| sentinel.configMap.* | string | `nil` | Custom Sentinel configuration file to include, templates are allowed both in the config map name and contents |
| sentinel.configMap.enabled | bool | `true` | Create a config map for Sentinel configuration |
| sentinel.configuration | string | `""` | Extra configurations to add to the Sentinel configuration file. Can be defined as a string, a key-value map, or an array of entries. See: https://github.com/redis/redis/blob/unstable/sentinel.conf |
| sentinel.configurationFile | string | `"sentinel.conf"` | Sentinel configuration file name in the config map |
| sentinel.downAfterMilliseconds | int | `10000` | Time in milliseconds an instance should not be reachable for a Sentinel starting to think it is down |
| sentinel.existingConfigMap | string | `""` | Name of an existing config map for extra configurations to add to the Sentinel configuration file |
| sentinel.failoverTimeout | int | `180000` | Timeout for a Redis failover to succeed |
| sentinel.headlessService.* | string | `nil` | Custom attributes for the Sentinel headless service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| sentinel.headlessService.annotations | object | `{}` | Custom annotations to add to the headless service for Sentinel |
| sentinel.headlessService.clusterIP | string | `"None"` |  |
| sentinel.headlessService.ports.* | int32 | `nil` | Headless service port override for custom Sentinel ports specified in `containerPorts.*` |
| sentinel.headlessService.ports.sentinel | int32 | `""` | Headless service port override for Sentinel client connections |
| sentinel.headlessService.publishNotReadyAddresses | bool | `true` | Disregard indications of ready/not-ready The primary use case for setting this field is for a StatefulSet's Headless Service to propagate SRV DNS records for its Pods for the purpose of peer discovery |
| sentinel.headlessService.type | string | `"ClusterIP"` | Sentinel headless service type |
| sentinel.masterSet | string | `"mymaster"` | Name of the Redis master set to monitor, which identifies a master and its replicas |
| sentinel.nodeCount | int | `3` | Number of Sentinels to deploy (must be 3 or greater for cluster consistency in case of failover) |
| sentinel.parallelSyncs | int | `1` | Number of Redis replicas that can be reconfigured to use the new master after a failover at the same time |
| sentinel.podTemplates.* | string | `nil` | Custom attributes for the pods in the Sentinel PodTemplate (see [`PodSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec)) |
| sentinel.podTemplates.annotations | object | See `values.yaml` | Annotations to add to all pods in Sentinel's StatefulSet PodTemplate |
| sentinel.podTemplates.containers | object | See `values.yaml` | Sentinel containers to deploy in the PodTemplate Each field has the container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| sentinel.podTemplates.containers.sentinel.* | string | `nil` | Custom attributes for the Sentinel container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| sentinel.podTemplates.containers.sentinel.args | list | `[]` | Arguments override for the Sentinel container entrypoint |
| sentinel.podTemplates.containers.sentinel.command | list | See `values.yaml` | Entrypoint override for the Sentinel container |
| sentinel.podTemplates.containers.sentinel.enabled | bool | `true` | Enable the Sentinel container in the PodTemplate |
| sentinel.podTemplates.containers.sentinel.env | object | See `values.yaml` | Object with the environment variables templates to use in the Sentinel container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| sentinel.podTemplates.containers.sentinel.envFrom | list | `[]` | List of sources from which to populate environment variables to the Sentinel container (e.g. a ConfigMaps or a Secret) |
| sentinel.podTemplates.containers.sentinel.image | string | `""` | Image for the Sentinel container |
| sentinel.podTemplates.containers.sentinel.imagePullPolicy | string | `""` | Image pull policy override for the Sentinel container |
| sentinel.podTemplates.containers.sentinel.livenessProbe.enabled | bool | `true` | Enable liveness probe for Sentinel |
| sentinel.podTemplates.containers.sentinel.livenessProbe.exec | object | See `values.yaml` | Command to execute for the Sentinel startup probe |
| sentinel.podTemplates.containers.sentinel.livenessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Sentinel liveness probe to be considered failed after having succeeded |
| sentinel.podTemplates.containers.sentinel.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the Sentinel container has started before liveness probes are initiated |
| sentinel.podTemplates.containers.sentinel.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Sentinel liveness probe |
| sentinel.podTemplates.containers.sentinel.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Sentinel liveness probe to be considered successful after having failed |
| sentinel.podTemplates.containers.sentinel.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Sentinel liveness probe times out |
| sentinel.podTemplates.containers.sentinel.ports | object | `{}` | Ports override for the Sentinel container (if set, `containerPorts.*` values will be ignored for this container) |
| sentinel.podTemplates.containers.sentinel.readinessProbe.enabled | bool | `true` | Enable readiness probe for Sentinel |
| sentinel.podTemplates.containers.sentinel.readinessProbe.exec | object | See `values.yaml` | Command to execute for the Sentinel startup probe |
| sentinel.podTemplates.containers.sentinel.readinessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Sentinel readiness probe to be considered failed after having succeeded |
| sentinel.podTemplates.containers.sentinel.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the Sentinel container has started before readiness probes are initiated |
| sentinel.podTemplates.containers.sentinel.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Sentinel readiness probe |
| sentinel.podTemplates.containers.sentinel.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Sentinel readiness probe to be considered successful after having failed |
| sentinel.podTemplates.containers.sentinel.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Sentinel readiness probe times out |
| sentinel.podTemplates.containers.sentinel.resources | object | `{}` | Custom resource requirements for the Sentinel container |
| sentinel.podTemplates.containers.sentinel.securityContext | object | `{}` | Security context override for the Sentinel container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| sentinel.podTemplates.containers.sentinel.startupProbe.enabled | bool | `false` | Enable startup probe for Sentinel |
| sentinel.podTemplates.containers.sentinel.startupProbe.exec | object | See `values.yaml` | Command to execute for the Sentinel startup probe |
| sentinel.podTemplates.containers.sentinel.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the Sentinel startup probe to be considered failed after having succeeded |
| sentinel.podTemplates.containers.sentinel.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before startup probes are initiated |
| sentinel.podTemplates.containers.sentinel.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Sentinel startup probe |
| sentinel.podTemplates.containers.sentinel.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the Sentinel startup probe to be considered successful after having failed |
| sentinel.podTemplates.containers.sentinel.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the Sentinel startup probe times out |
| sentinel.podTemplates.containers.sentinel.volumeMounts | object | See `values.yaml` | Volume mount templates for the Sentinel container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| sentinel.podTemplates.imagePullSecrets | list | `[]` | Custom pull secrets for the Sentinel container in the PodTemplate |
| sentinel.podTemplates.initContainers | object | See `values.yaml` | Init containers to deploy in the Sentinel PodTemplate Each field has the init container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| sentinel.podTemplates.initContainers.volume-permissions.* | string | `nil` | Custom attributes for the Sentinel volume-permissions init container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| sentinel.podTemplates.initContainers.volume-permissions.args | list | `[]` | Arguments override for the Sentinel volume-permissions init container entrypoint |
| sentinel.podTemplates.initContainers.volume-permissions.command | list | See `values.yaml` | Entrypoint override for the Sentinel volume-permissions container |
| sentinel.podTemplates.initContainers.volume-permissions.enabled | bool | `false` | Enable the volume-permissions init container in the Sentinel PodTemplate |
| sentinel.podTemplates.initContainers.volume-permissions.env | object | No environment variables are set | Object with the environment variables templates to use in the Sentinel volume-permissions init container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| sentinel.podTemplates.initContainers.volume-permissions.envFrom | list | `[]` | List of sources from which to populate environment variables to the Sentinel volume-permissions init container (e.g. a ConfigMaps or a Secret) |
| sentinel.podTemplates.initContainers.volume-permissions.image | string | `""` | Image override for the Sentinel volume-permissions init container (if set, `images.volume-permissions.{name,tag,digest}` values will be ignored for this container) |
| sentinel.podTemplates.initContainers.volume-permissions.imagePullPolicy | string | `""` | Image pull policy override for the Sentinel volume-permissions init container (if set `images.volume-permissions.pullPolicy` values will be ignored for this container) |
| sentinel.podTemplates.initContainers.volume-permissions.resources | object | `{}` | Sentinel init-containers resource requirements |
| sentinel.podTemplates.initContainers.volume-permissions.securityContext | object | See `values.yaml` | Security context override for the Sentinel volume-permissions init container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| sentinel.podTemplates.initContainers.volume-permissions.volumeMounts | object | See `values.yaml` | Custom volume mounts for the Sentinel volume-permissions init container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| sentinel.podTemplates.labels | object | `{}` | Labels to add to all pods in Sentinel's StatefulSet PodTemplate |
| sentinel.podTemplates.securityContext | object | `{}` | Security context override for the pods in the Sentinel PodTemplate (if set, `podSecurityContext.*` values will be ignored) |
| sentinel.podTemplates.serviceAccountName | string | `""` | Service account name override for the pods in the Sentinel PodTemplate (if set, `serviceAccount.name` will be ignored) |
| sentinel.podTemplates.volumes | object | See `values.yaml` | Volume templates for the Sentinel PodTemplate, templates are allowed in all fields Each field has the volume name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| sentinel.quorum | int | `2` | Number of Sentinels that must agree that a master is not reachable to start a failover proceedure. |
| sentinel.service.* | string | `nil` | Custom attributes for the Sentinel service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| sentinel.service.annotations | object | `{}` | Custom annotations to add to the service for Sentinel |
| sentinel.service.enabled | bool | `true` | Create a service for Sentinel (apart from the headless service) |
| sentinel.service.nodePorts.* | int32 | `nil` | Service nodePort override for custom Sentinel ports specified in `containerPorts.*` |
| sentinel.service.nodePorts.sentinel | int32 | `""` | Service nodePort override for Sentinel connections |
| sentinel.service.ports.* | int32 | `nil` | Service port override for custom Sentinel ports specified in `containerPorts.*` |
| sentinel.service.ports.sentinel | int32 | `""` | Service port override for Sentinel connections |
| sentinel.service.type | string | `"ClusterIP"` | Sentinel service type |
| sentinel.statefulset.* | string | `nil` | Custom attributes for the Sentinel StatefulSet (see [`StatefulSetSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/#StatefulSetSpec)) |
| sentinel.statefulset.enabled | bool | `true` | Enable the StatefulSet template for Sentinel |
| sentinel.statefulset.persistentVolumeClaimRetentionPolicy | object | `{}` | Lifecycle of the persistent volume claims created from Sentinel volumeClaimTemplates |
| sentinel.statefulset.podManagementPolicy | string | `"Parallel"` | How Sentinel pods are created during the initial scaleup |
| sentinel.statefulset.replicas | string | `""` | Desired number of PodTemplate replicas for Sentinel (overrides `sentinel.nodeCount`) |
| sentinel.statefulset.serviceName | string | `""` | Override for Sentinel's StatefulSet serviceName field, it will be autogenerated if unset |
| sentinel.statefulset.template | object | `{}` | Template to use for all pods created by the Sentinel StatefulSet (overrides `podTemplates.*`) |
| sentinel.statefulset.updateStrategy | object | See `values.yaml` | Strategy that will be employed to update the pods in the Sentinel StatefulSet |
| service.* | string | `nil` | Custom attributes for the Redis service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| service.annotations | object | `{}` | Custom annotations to add to the service for Redis |
| service.enabled | bool | `true` | Create a service for Redis (apart from the headless service) |
| service.nodePorts.* | int32 | `nil` | Service nodePort override for custom Redis ports specified in `containerPorts.*` |
| service.nodePorts.redis | int32 | `""` | Service nodePort override for Redis client connections |
| service.ports.* | int32 | `nil` | Service port override for custom Redis ports specified in `containerPorts.*` |
| service.ports.redis | int32 | `""` | Service port override for Redis client connections |
| service.type | string | `"ClusterIP"` | Redis service type |
| serviceAccount.annotations | object | `{}` | Add custom annotations to the ServiceAccount |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether pods running as this service account should have an API token automatically mounted |
| serviceAccount.enabled | bool | `false` | Create or use an existing service account |
| serviceAccount.imagePullSecrets | list | `[]` | List of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount |
| serviceAccount.labels | object | `{}` | Add custom labels to the ServiceAccount |
| serviceAccount.name | string | `""` | Name of the ServiceAccount to use |
| serviceAccount.secrets | list | `[]` | List of secrets in the same namespace that pods running using this ServiceAccount are allowed to use |
| statefulset.* | string | `nil` | Custom attributes for the Redis StatefulSet (see [`StatefulSetSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/#StatefulSetSpec)) |
| statefulset.enabled | bool | `true` | Enable the StatefulSet template for Redis standalone mode |
| statefulset.persistentVolumeClaimRetentionPolicy | object | `{}` | Lifecycle of the persistent volume claims created from Redis volumeClaimTemplates |
| statefulset.podManagementPolicy | string | `"Parallel"` | How Redis pods are created during the initial scaleup |
| statefulset.replicas | string | `""` | Desired number of PodTemplate replicas for Redis (overrides `nodeCount`) |
| statefulset.serviceName | string | `""` | Override for the Redis' StatefulSet serviceName field, it will be autogenerated if unset |
| statefulset.template | object | `{}` | Template to use for all pods created by the Redis StatefulSet (overrides `podTemplates.*`) |
| statefulset.updateStrategy | object | See `values.yaml` | Strategy that will be employed to update the pods in the Redis StatefulSet |
| tls.authClients | bool | `true` | Whether to require Redis clients to authenticate with a valid certificate (authenticated against the trusted root CA certificate) |
| tls.caCertFilename | string | `""` | CA certificate filename in the secret |
| tls.certFilename | string | `""` | Certificate filename in the secret |
| tls.cluster | bool | `true` | Whether to enable TLS for the cluster bus and cross-node connections (only for Redis Cluster architecture) |
| tls.dhParamsfilename | string | `""` | Filename in the secret containing the DH params (for DH-based ciphers) |
| tls.enabled | bool | `false` | Enable TLS |
| tls.existingSecret | string | `""` | Name of the secret containing the Redis certificates |
| tls.keyFilename | string | `""` | Certificate key filename in the secret |
| tls.replication | bool | `true` | Whether to use TLS for outgoing connections from replicas to the master |
| useHostnames | bool | `true` | Make Redis announce host names instead of IP addresses with replication, Sentinel or Cluster modes. See: https://redis.io/docs/latest/operate/oss_and_stack/management/sentinel/#ip-addresses-and-dns-names |

### Override Values

To override a parameter, add *--set* flags to the *helm install* command. For example:

```console
helm install my-release --set images.redis.tag=7.4.2 oci://dp.apps.rancher.io/charts/redis
```

Alternatively, you can override the parameter values using a custom YAML file with the *-f* flag. For example:

```console
helm install my-release -f custom-values.yaml oci://dp.apps.rancher.io/charts/redis
```

Read more about [Values files](https://helm.sh/docs/chart_template_guide/values_files/) in the [Helm documentation](https://helm.sh/docs/).

## Missing Features

The following features are acknowledged missing from this Helm chart, and are expected to be added in a future revision:

* External access to Redis access (from outside of the Kubernetes cluster)
* Proxy to the current master node in Redis Sentinel configurations

# Apache Kafka Helm Chart

> [Apache Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

## Introduction

This Helm chart bootstraps an [Apache Kafka](https://kafka.apache.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Quick Start

```console
helm install my-release oci://dp.apps.rancher.io/charts/apache-kafka \
    --set global.imagePullSecrets={application-collection}
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
    oci://dp.apps.rancher.io/charts/apache-kafka \
```

This deploys the application to the Kubernetes cluster using the default configuration provided by the Helm chart.

> NOTE: You can follow [these steps](https://docs.apps.rancher.io/get-started/authentication/#kubernetes)
> to create and setup the image pull secrets, if you don't have them already.

## Uninstall Chart

To uninstall the Helm chart with the release name *my-release*:

```console
helm uninstall my-release
```

## Configuration

To view support configuration options and documentation, run:

```console
helm show values oci://dp.apps.rancher.io/charts/apache-kafka
```

### Global Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.imagePullSecrets | list | `[]` | Global override for container image registry pull secrets |
| global.imageRegistry | string | `""` | Global override for container image registry |
| global.storageClassName | string | `""` | Global override for the storage class |

### General Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.enabled | bool | `true` | Enable Apache Kafka password authentication |
| auth.sasl.enabledMechanisms | string | `"PLAIN"` | Comma-separated list of enabled SASL mechanisms. Valid values are `GSSAPI`, `OAUTHBEARER`, and `PLAIN` |
| auth.sasl.gssapi.existingSecret | string | `""` | Name of the secret containing the Apache Kafka keyTab |
| auth.sasl.gssapi.kerberosServiceName | string | `""` | The Kerberos principal name that Kafka runs as |
| auth.sasl.oauthbearer.jwksEndpointUrl | string | `""` | The OAuth/OIDC provider URL from which the provider's JWKS (JSON Web Key Set) can be retrieved |
| auth.sasl.oauthbearer.tokenEndpointUrl | string | `""` | The URL for the OAuth/OIDC identity provider |
| auth.sasl.oauthbearer.unsecuredLoginClaimSub | string | `""` | Used by brokers to configure the subject (sub) claim, which determines the user for inter-broker connections |
| auth.sasl.plain.existingSecret | string | `""` | Name of a secret containing the Apache Kafka password (if set, `auth.user` and `auth.password` will be ignored) |
| auth.sasl.plain.interbrokerPassword | string | `"admin_password"` | Password for the interbroker user |
| auth.sasl.plain.interbrokerUsername | string | `"admin"` | User for inter-broker communications |
| auth.sasl.plain.passwordKey | string | `""` | Password key in the secret @default `password` |
| auth.sasl.plain.users | object | `{"user_test":"password_test"}` | Username and password key-name map for client-broker communications |
| commonAnnotations | object | `{}` | Annotations to add to all deployed objects |
| commonLabels | object | `{}` | Labels to add to all deployed objects |
| containerPorts.* | int32 | `nil` | Custom port number to expose in the Apache Kafka containers |
| containerPorts.client | int32 | `9092` | Apache Kafka port number for client connections |
| containerPorts.controller | int32 | `9093` | Apache Kafka port number for controller connections |
| containerPorts.interbroker | int32 | `9094` | Apache Kafka port number for interbroker connections |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Allow privilege escalation within containers |
| containerSecurityContext.enabled | bool | `true` | Enable container security context |
| containerSecurityContext.runAsNonRoot | bool | `true` | Run containers as a non-root user |
| containerSecurityContext.runAsUser | int | `1000` | Which user ID to run the container as |
| extraManifests | list | `[]` | Additional Kubernetes manifests to include in the chart |
| fullnameOverride | string | `""` | Override the resource name |
| images.broker.digest | string | `""` | Image digest to use for the Apache Kafka broker container (if set, `images.broker.tag` will be ignored) |
| images.broker.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the Apache Kafka broker container |
| images.broker.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the Apache Kafka broker container |
| images.broker.repository | string | `"containers/apache-kafka"` | Image repository to use for the Apache Kafka broker container |
| images.broker.tag | string | `"3.9.0"` | Image tag to use for the Apache Kafka broker container |
| images.controller.digest | string | `""` | Image digest to use for the Apache Kafka controller container (if set, `images.controller.tag` will be ignored) |
| images.controller.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the Apache Kafka controller container |
| images.controller.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the Apache Kafka controller container |
| images.controller.repository | string | `"containers/apache-kafka"` | Image repository to use for the Apache Kafka controller container |
| images.controller.tag | string | `"3.9.0"` | Image tag to use for the Apache Kafka controller container |
| images.volume-permissions.digest | string | `""` | Image digest to use for the volume permissions init container (if set, `images.volume-permissions.tag` will be ignored) |
| images.volume-permissions.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the volume-permissions container |
| images.volume-permissions.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the volume permissions init container |
| images.volume-permissions.repository | string | `"containers/bci-busybox"` | Image pository to use for the volume permissions init container |
| images.volume-permissions.tag | string | `"15.6"` | Image tag to use for the volume permissions init container |
| nameOverride | string | `""` | Override the resource name prefix (will keep the release name) |
| networkPolicy.allowExternalConnections | bool | `true` | Allow all external connections from and to the pods |
| networkPolicy.egress.allowExternalConnections | bool | `true` | Allow all external egress connections from the pods (requires also `networkPolicy.allowExternalConnections`) |
| networkPolicy.egress.enabled | bool | `true` | Create an egress network policy (requires also `networkPolicy.enabled`) |
| networkPolicy.egress.extraRules | list | `[]` | Custom additional egress rules to enable in the NetworkPolicy resource |
| networkPolicy.egress.namespaceLabels | object | `{}` | List of namespace labels for which to allow egress connections, when external connections are disallowed |
| networkPolicy.egress.podLabels | object | `{}` | List of pod labels for which to allow egress connections, when external connections are disallowed |
| networkPolicy.egress.ports.* | int32 | `nil` | Network policy port override for custom ports specified in `containerPorts.*` for egress connections |
| networkPolicy.egress.ports.client | int32 | `""` | Network policy port override for Apache Kafka client connections for egress connections |
| networkPolicy.egress.ports.peer | int32 | `""` | Network policy port override for Apache Kafka peer connections for egress connections |
| networkPolicy.enabled | bool | `false` | Create a NetworkPolicy resource |
| networkPolicy.ingress.allowExternalConnections | bool | `true` | Allow all external ingress connections to the pods (requires also `networkPolicy.allowExternalConnections`) |
| networkPolicy.ingress.enabled | bool | `true` | Create an ingress network policy (requires also `networkPolicy.enabled`) |
| networkPolicy.ingress.extraRules | list | `[]` | Custom additional ingress rules to enable in the NetworkPolicy resource |
| networkPolicy.ingress.namespaceLabels | object | `{}` | List of namespace labels for which to allow ingress connections, when external connections are disallowed |
| networkPolicy.ingress.podLabels | object | `{}` | List of pod labels for which to allow ingress connections, when external connections are disallowed |
| networkPolicy.ingress.ports.* | int32 | `nil` | Network policy port override for custom ports specified in `containerPorts.*` for ingress connections |
| networkPolicy.ingress.ports.client | int32 | `""` | Network policy port override for Apache Kafka client connections for ingress connections |
| networkPolicy.ingress.ports.peer | int32 | `""` | Network policy port override for Apache Kafka peer connections for ingress connections |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Persistent volume access modes |
| persistence.annotations | object | `{}` | Custom annotations to add to the persistent volume claims used by Apache Kafka pods |
| persistence.enabled | bool | `true` | Enable persistent volume claims for Apache Kafka pods |
| persistence.existingClaim | string | `""` | Name of an existing PersistentVolumeClaim to use by Apache Kafka pods |
| persistence.labels | object | `{}` | Custom labels to add to the persistent volume claims used by Apache Kafka pods |
| persistence.resources.requests.storage | string | `"8Gi"` | Size of the persistent volume claim to create for Apache Kafka pods |
| persistence.storageClassName | string | `""` | Storage class name to use for the Apache Kafka persistent volume claim |
| podDisruptionBudget.enabled | bool | `false` | Create a pod disruption budget |
| podDisruptionBudget.maxUnavailable | string | `""` | Number of pods from that can be unavailable after the eviction, this option is mutually exclusive with minAvailable |
| podDisruptionBudget.minAvailable | string | `""` | Number of pods from that set that must still be available after the eviction, this option is mutually exclusive with maxUnavailable |
| podSecurityContext.enabled | bool | `true` | Enable pod security context |
| podSecurityContext.fsGroup | int | `1000` | Group ID that will write to persistent volumes |
| serviceAccount.annotations | object | `{}` | Add custom annotations to the ServiceAccount |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether pods running as this service account should have an API token automatically mounted |
| serviceAccount.enabled | bool | `false` | Create or use an existing service account |
| serviceAccount.imagePullSecrets | list | `[]` | List of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount |
| serviceAccount.labels | object | `{}` | Add custom labels to the ServiceAccount |
| serviceAccount.name | string | `""` | Name of the ServiceAccount to use |
| serviceAccount.secrets | list | `[]` | List of secrets in the same namespace that pods running using this ServiceAccount are allowed to use |
| tls.caCertFilename | string | `""` | CA certificate filename in the secret. If the CA certificate is included in the PEM cert, use the same value as `tls.certificateChainFilename` |
| tls.clientAuth | string | `"none"` | Configures kafka broker to request client authentication. Valid values are `none`, `required` and `requested` |
| tls.enabled | bool | `false` | Enable TLS. Requires setting the proper `auth.listeners.xxxx.protocol` |
| tls.existingSecret | string | `""` | Name of the secret containing the Apache Kafka certificates |
| tls.format | string | `"JKS"` | Store format for file-based keys and trust stores. Valid values are `JKS` and `PEM` |
| tls.hostnameVerification | bool | `true` | Whether to require Apache Kafka to perform host name verification |
| tls.keystoreKeyPassword | string | `""` | The password of the private key in the JKS keystores or the PEM keys, depending on `tls.format` |
| tls.keystorePassword | string | `""` | Password to access the JKS keystore file in case it is encrypted |
| tls.truststoreFilename | string | `""` | Truststore filename in the secret |
| tls.truststorePassword | string | `""` | Password to access the JKS truststore file in case it is encrypted |

### Kafka cluster Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cluster.clusterConfigMap | string | `""` | Name of a configMap containing the clusterID (if set, `cluster.clusterID` will be ignored) |
| cluster.clusterID | string | `""` | Unique clusterID shared among all nodes |
| cluster.clusterIDKey | string | `"clusterID"` | clusterID key in the configMap @default `clusterID` |
| cluster.controllerBrokerRole | bool | `true` | Whether the controller nodes will also function as brokers |
| cluster.disksPerBroker | int32 | `1` | Number of disks per each Apache Kafka node |
| cluster.listeners.* | string | `nil` | Custom Apache Kafka listeners |
| cluster.listeners.client.name | string | `"CLIENT"` | Apache Kafka client's listener name |
| cluster.listeners.client.protocol | string | `"SASL_PLAINTEXT"` | Apache Kafka client's listener security protocol. Valid values are `PLAINTEXT`, `SASL_PLAINTEXT`, `SSL` and `SASL_SSL` |
| cluster.listeners.client.saslMechanism | string | `"PLAIN"` | Apache Kafka client's listener SASL mechanism. Valid values are `GSSAPI`, `OAUTHBEARER`, and `PLAIN` |
| cluster.listeners.controller.name | string | `"CONTROLLER"` | Apache Kafka controller's listener name |
| cluster.listeners.controller.protocol | string | `"SASL_PLAINTEXT"` | Apache Kafka controller's listener security protocol. Valid values are `PLAINTEXT`, `SASL_PLAINTEXT`, `SSL` and `SASL_SSL` |
| cluster.listeners.controller.saslMechanism | string | `"PLAIN"` | Apache Kafka controller's listener SASL mechanism. Valid values are `GSSAPI`, `OAUTHBEARER`, and `PLAIN` |
| cluster.listeners.interbroker.name | string | `"INTERBROKER"` | Apache Kafka interbroker's listener name |
| cluster.listeners.interbroker.protocol | string | `"SASL_PLAINTEXT"` | Apache Kafka interbroker's listener security protocol. Valid values are `PLAINTEXT`, `SASL_PLAINTEXT`, `SSL` and `SASL_SSL` |
| cluster.listeners.interbroker.saslMechanism | string | `"PLAIN"` | Apache Kafka interbroker's listener SASL mechanism. Valid values are `GSSAPI`, `OAUTHBEARER`, and `PLAIN` |
| cluster.minBrokerID | int | `1000` | Minimum node ID brokers should start from. Should always be greater than `cluster.nodeCount.controller` |
| cluster.nodeCount.broker | int32 | `3` | Desired number of Apache Kafka broker nodes to deploy (requires `broker.enabled`) |
| cluster.nodeCount.controller | int32 | `3` | Desired number of Apache Kafka controller nodes to deploy |
| cluster.numPartitions | int32 | `1` | Number of log partitions per topic |
| cluster.offsetsTopicReplicationFactor | int32 | `2` | The replication factor for the offsets topic |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |

### Controller node Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| controller.configMap | object | See `values.yaml` | ConfigMaps to deploy |
| controller.configMap.* | string | `nil` | Custom configuration file to include, templates are allowed both in the config map name and contents |
| controller.configMap.enabled | string | `"{{ and (not .Values.controller.existingConfigMap) (not (empty .Values.controller.configuration)) }}"` | Create a config map for Apache Kafka configuration |
| controller.configuration | string | `""` | Extra configurations to add to the controller configuration file. Can be defined as a string, a key-value (string-string) map, or an array of entries. |
| controller.configurationFile | string | `"server.properties"` | Configuration file name for the controllers' server properties in the config map |
| controller.existingConfigMap | string | `""` | Name of an existing config map for extra configurations to add to the Apache Kafka configuration file |
| controller.headlessService.* | string | `nil` | Custom attributes for the Apache Kafka headless service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| controller.headlessService.annotations | object | `{}` | Custom annotations to add to the headless service for Apache Kafka |
| controller.headlessService.clusterIP | string | `"None"` |  |
| controller.headlessService.ports.* | int32 | `nil` | Headless service port override for custom Apache Kafka ports specified in `containerPorts.*` |
| controller.headlessService.ports.client | int32 | `""` | Headless service port override for Apache Kafka client connections |
| controller.headlessService.ports.controller | int32 | `""` | Apache Kafka port number for controller connections |
| controller.headlessService.ports.interbroker | int32 | `""` | Apache Kafka port number for interbroker connections |
| controller.headlessService.publishNotReadyAddresses | bool | `true` | Disregard indications of ready/not-ready The primary use case for setting this field is for a StatefulSet's Headless Service to propagate SRV DNS records for its Pods for the purpose of peer discovery |
| controller.headlessService.type | string | `"ClusterIP"` | Apache Kafka headless service type |
| controller.heapOpts | string | `"-Xms512M -Xmx512M"` | Java heapOpts |
| controller.podTemplates.* | string | `nil` | Custom attributes for the pods in the Apache Kafka PodTemplate (see [`PodSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec)) |
| controller.podTemplates.annotations | object | See `values.yaml` | Annotations to add to all pods in the Apache Kafka StatefulSet's PodTemplate |
| controller.podTemplates.containers | object | See `values.yaml` | Containers to deploy in the Apache Kafka PodTemplate Each field has the container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| controller.podTemplates.containers.controller.* | string | `nil` | Custom attributes for the Apache Kafka container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| controller.podTemplates.containers.controller.args | list | `[]` | Arguments override for the Apache Kafka container entrypoint |
| controller.podTemplates.containers.controller.command | list | See `values.yaml` | Entrypoint override for the Apache Kafka container |
| controller.podTemplates.containers.controller.enabled | bool | `true` | Enable the Apache Kafka container in the PodTemplate |
| controller.podTemplates.containers.controller.env | object | See `values.yaml` | Object with the environment variables templates to use in the Apache Kafka container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| controller.podTemplates.containers.controller.envFrom | list | `[]` | List of sources from which to populate environment variables to the Apache Kafka container (e.g. a ConfigMaps or a Secret) |
| controller.podTemplates.containers.controller.image | string | `""` | Image override for the Apache Kafka container (if set, `images.controller.{name,tag,digest}` values will be ignored for this container) |
| controller.podTemplates.containers.controller.imagePullPolicy | string | `""` | Image pull policy override for the Apache Kafka container (if set `images.controller.pullPolicy` values will be ignored for this container) |
| controller.podTemplates.containers.controller.livenessProbe.enabled | bool | `true` | Enable liveness probe for Apache Kafka |
| controller.podTemplates.containers.controller.livenessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Apache Kafka liveness probe to be considered failed after having succeeded |
| controller.podTemplates.containers.controller.livenessProbe.initialDelaySeconds | int | `45` | Number of seconds after the Apache Kafka container has started before liveness probes are initiated |
| controller.podTemplates.containers.controller.livenessProbe.periodSeconds | int | `15` | How often (in seconds) to perform the Apache Kafka liveness probe |
| controller.podTemplates.containers.controller.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Apache Kafka liveness probe to be considered successful after having failed |
| controller.podTemplates.containers.controller.livenessProbe.tcpSocket | object | See `values.yaml` | Command to execute for the Apache Kafka startup probe |
| controller.podTemplates.containers.controller.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Apache Kafka liveness probe times out |
| controller.podTemplates.containers.controller.ports | object | `{}` | Ports override for the Apache Kafka container (if set, `containerPorts.*` values will be ignored for this container) |
| controller.podTemplates.containers.controller.readinessProbe.enabled | bool | `true` | Enable readiness probe for Apache Kafka |
| controller.podTemplates.containers.controller.readinessProbe.exec | object | See `values.yaml` | Command to execute for the Apache Kafka startup probe |
| controller.podTemplates.containers.controller.readinessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Apache Kafka readiness probe to be considered failed after having succeeded |
| controller.podTemplates.containers.controller.readinessProbe.initialDelaySeconds | int | `30` | Number of seconds after the Apache Kafka container has started before readiness probes are initiated |
| controller.podTemplates.containers.controller.readinessProbe.periodSeconds | int | `15` | How often (in seconds) to perform the Apache Kafka readiness probe |
| controller.podTemplates.containers.controller.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Apache Kafka readiness probe to be considered successful after having failed |
| controller.podTemplates.containers.controller.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Apache Kafka readiness probe times out |
| controller.podTemplates.containers.controller.resources | object | `{}` | Custom resource requirements for the Apache Kafka container |
| controller.podTemplates.containers.controller.securityContext | object | `{}` | Security context override for the Apache Kafka container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| controller.podTemplates.containers.controller.startupProbe.enabled | bool | `false` | Enable startup probe for Apache Kafka |
| controller.podTemplates.containers.controller.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the Apache Kafka startup probe to be considered failed after having succeeded |
| controller.podTemplates.containers.controller.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the Apache Kafka container has started before startup probes are initiated |
| controller.podTemplates.containers.controller.startupProbe.periodSeconds | int | `15` | How often (in seconds) to perform the Apache Kafka startup probe |
| controller.podTemplates.containers.controller.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the Apache Kafka startup probe to be considered successful after having failed |
| controller.podTemplates.containers.controller.startupProbe.tcpSocket | object | See `values.yaml` | Port number used to check if the Apache Kafka service is alive |
| controller.podTemplates.containers.controller.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the Apache Kafka startup probe times out |
| controller.podTemplates.containers.controller.volumeMounts | object | See `values.yaml` | Volume mount templates for the Apache Kafka container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| controller.podTemplates.imagePullSecrets | list | `[]` | Custom pull secrets for the Apache Kafka container in the PodTemplate |
| controller.podTemplates.initContainers | object | See `values.yaml` | Init containers to deploy in the Apache Kafka PodTemplate Each field has the init container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| controller.podTemplates.initContainers.volume-permissions.* | string | `nil` | Custom attributes for the Apache Kafka volume-permissions init container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| controller.podTemplates.initContainers.volume-permissions.args | list | `[]` | Arguments override for the Apache Kafka volume-permissions init container entrypoint |
| controller.podTemplates.initContainers.volume-permissions.command | list | See `values.yaml` | Entrypoint override for the Apache Kafka volume-permissions container |
| controller.podTemplates.initContainers.volume-permissions.enabled | bool | `false` | Enable the volume-permissions init container in the Apache Kafka PodTemplate |
| controller.podTemplates.initContainers.volume-permissions.env | object | No environment variables are set | Object with the environment variables templates to use in the Apache Kafka volume-permissions init container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| controller.podTemplates.initContainers.volume-permissions.envFrom | list | `[]` | List of sources from which to populate environment variables to the Apache Kafka volume-permissions init container (e.g. a ConfigMaps or a Secret) |
| controller.podTemplates.initContainers.volume-permissions.image | string | `""` | Image override for the Apache Kafka volume-permissions init container (if set, `images.volume-permissions.{name,tag,digest}` values will be ignored for this container) |
| controller.podTemplates.initContainers.volume-permissions.imagePullPolicy | string | `""` | Image pull policy override for the Apache Kafka volume-permissions init container (if set `images.volume-permissions.pullPolicy` values will be ignored for this container) |
| controller.podTemplates.initContainers.volume-permissions.resources | object | `{}` | Apache Kafka init-containers resource requirements |
| controller.podTemplates.initContainers.volume-permissions.securityContext | object | See `values.yaml` | Security context override for the Apache Kafka volume-permissions init container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| controller.podTemplates.initContainers.volume-permissions.volumeMounts | object | See `values.yaml` | Custom volume mounts for the Apache Kafka volume-permissions init container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| controller.podTemplates.labels | object | `{}` | Labels to add to all pods in the Apache Kafka StatefulSet's PodTemplate |
| controller.podTemplates.securityContext | object | `{}` | Security context override for the pods in the Apache Kafka PodTemplate (if set, `podSecurityContext.*` values will be ignored) |
| controller.podTemplates.serviceAccountName | string | `""` | Service account name override for the pods in the Apache Kafka PodTemplate (if set, `serviceAccount.name` will be ignored) |
| controller.podTemplates.terminationGracePeriodSeconds | int | `120` | Number of seconds prior to the container being forcibly terminated when marked for deletion or restarted. |
| controller.podTemplates.volumes | object | See `values.yaml` | Volume templates for the Apache Kafka PodTemplate, templates are allowed in all fields Each field has the volume name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| controller.secret | object | See `values.yaml` | Secrets to deploy |
| controller.secret.* | string | `nil` | Custom secret to include, templates are allowed both in the secret name and contents |
| controller.secret.enabled | string | `true` if authentication is enabled without existing secret, `false` otherwise | Create a secret for Apache Kafka credentials |
| controller.service.* | string | `nil` | Custom attributes for the Apache Kafka service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| controller.service.annotations | object | `{}` | Custom annotations to add to the service for Apache Kafka |
| controller.service.enabled | bool | `true` | Create a service for Apache Kafka (apart from the headless service) |
| controller.service.nodePorts.* | int32 | `nil` | Service nodePort override for custom Apache Kafka ports specified in `containerPorts.*` |
| controller.service.nodePorts.client | int32 | `""` | Service nodePort override for Apache Kafka client connections |
| controller.service.nodePorts.controller | int32 | `""` | Service nodePort override for Apache Kafka controller connections |
| controller.service.nodePorts.interbroker | int32 | `""` | Service nodePort override for Apache Kafka interbroker connections |
| controller.service.ports.* | int32 | `nil` | Service port override for custom Apache Kafka ports specified in `containerPorts.*` |
| controller.service.ports.client | int32 | `""` | Service port override for Apache Kafka client connections |
| controller.service.ports.controller | int32 | `""` | Apache Kafka port number for controller connections |
| controller.service.ports.interbroker | int32 | `""` | Apache Kafka port number for interbroker connections |
| controller.service.type | string | `"ClusterIP"` | Apache Kafka service type |
| controller.statefulset.* | string | `nil` | Custom attributes for the Apache Kafka StatefulSet (see [`StatefulSetSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/#StatefulSetSpec)) |
| controller.statefulset.enabled | bool | `true` | Enable the StatefulSet template for Apache Kafka standalone mode |
| controller.statefulset.persistentVolumeClaimRetentionPolicy | object | `{}` | Lifecycle of the persistent volume claims created from Apache Kafka volumeClaimTemplates |
| controller.statefulset.podManagementPolicy | string | `"Parallel"` | How Apache Kafka pods are created during the initial scaleup |
| controller.statefulset.replicas | string | `""` | Desired number of PodTemplate replicas for Apache Kafka controller (overrides `cluster.nodeCount.controller`) |
| controller.statefulset.serviceName | string | `""` | Override for the Apache Kafka' StatefulSet serviceName field, it will be autogenerated if unset |
| controller.statefulset.template | object | `{}` | Template to use for all pods created by the Apache Kafka StatefulSet (overrides `podTemplates.*`) |
| controller.statefulset.updateStrategy | object | See `values.yaml` | Strategy that will be employed to update the pods in the Apache Kafka StatefulSet |
| controller.statefulset.volumeClaimTemplates | object | See `values.yaml` | Volume claim templates for the Apache Kafka statefulset, templates are allowed in all fields Each field has the volumeClaimTemplate name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |

### Broker node Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| broker.configMap | object | See `values.yaml` | ConfigMaps to deploy |
| broker.configMap.* | string | `nil` | Custom configuration file to include, templates are allowed both in the config map name and contents |
| broker.configMap.enabled | string | `"{{ and (not .Values.broker.existingConfigMap) (not (empty .Values.broker.configuration)) }}"` | Create a config map for Apache Kafka configuration |
| broker.configuration | string | `""` | Extra configurations to add to the controller configuration file. Can be defined as a string, a key-value (string-string) map, or an array of entries. |
| broker.configurationFile | string | `"server.properties"` | Configuration file name for the brokers' server properties in the config map |
| broker.enabled | bool | `false` | Whether to deploy broker-only nodes |
| broker.existingConfigMap | string | `""` | Name of an existing config map for extra configurations to add to the Apache Kafka configuration file |
| broker.headlessService.* | string | `nil` | Custom attributes for the Apache Kafka headless service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| broker.headlessService.annotations | object | `{}` | Custom annotations to add to the headless service for Apache Kafka |
| broker.headlessService.clusterIP | string | `"None"` |  |
| broker.headlessService.ports.* | int32 | `nil` | Headless service port override for custom Apache Kafka ports specified in `containerPorts.*` |
| broker.headlessService.ports.client | int32 | `""` | Headless service port override for Apache Kafka client connections |
| broker.headlessService.ports.controller | int32 | `""` | Apache Kafka port number for controller connections |
| broker.headlessService.ports.interbroker | int32 | `""` | Apache Kafka port number for interbroker connections |
| broker.headlessService.publishNotReadyAddresses | bool | `true` | Disregard indications of ready/not-ready The primary use case for setting this field is for a StatefulSet's Headless Service to propagate SRV DNS records for its Pods for the purpose of peer discovery |
| broker.headlessService.type | string | `"ClusterIP"` | Apache Kafka headless service type |
| broker.heapOpts | string | `"-Xms512M -Xmx512M"` | Java heapOpts |
| broker.podTemplates.* | string | `nil` | Custom attributes for the pods in the Apache Kafka PodTemplate (see [`PodSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec)) |
| broker.podTemplates.annotations | object | See `values.yaml` | Annotations to add to all pods in the Apache Kafka StatefulSet's PodTemplate |
| broker.podTemplates.containers | object | See `values.yaml` | Containers to deploy in the Apache Kafka PodTemplate Each field has the container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| broker.podTemplates.containers.broker.* | string | `nil` | Custom attributes for the Apache Kafka container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| broker.podTemplates.containers.broker.args | list | `[]` | Arguments override for the Apache Kafka container entrypoint |
| broker.podTemplates.containers.broker.command | list | See `values.yaml` | Entrypoint override for the Apache Kafka container |
| broker.podTemplates.containers.broker.enabled | bool | `true` | Enable the Apache Kafka container in the PodTemplate |
| broker.podTemplates.containers.broker.env | object | See `values.yaml` | Object with the environment variables templates to use in the Apache Kafka container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| broker.podTemplates.containers.broker.envFrom | list | `[]` | List of sources from which to populate environment variables to the Apache Kafka container (e.g. a ConfigMaps or a Secret) |
| broker.podTemplates.containers.broker.image | string | `""` | Image override for the Apache Kafka container (if set, `images.broker.{name,tag,digest}` values will be ignored for this container) |
| broker.podTemplates.containers.broker.imagePullPolicy | string | `""` | Image pull policy override for the Apache Kafka container (if set `images.broker.pullPolicy` values will be ignored for this container) |
| broker.podTemplates.containers.broker.livenessProbe.enabled | bool | `true` | Enable liveness probe for Apache Kafka |
| broker.podTemplates.containers.broker.livenessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Apache Kafka liveness probe to be considered failed after having succeeded |
| broker.podTemplates.containers.broker.livenessProbe.initialDelaySeconds | int | `45` | Number of seconds after the Apache Kafka container has started before liveness probes are initiated |
| broker.podTemplates.containers.broker.livenessProbe.periodSeconds | int | `15` | How often (in seconds) to perform the Apache Kafka liveness probe |
| broker.podTemplates.containers.broker.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Apache Kafka liveness probe to be considered successful after having failed |
| broker.podTemplates.containers.broker.livenessProbe.tcpSocket | object | See `values.yaml` | Command to execute for the Apache Kafka startup probe |
| broker.podTemplates.containers.broker.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Apache Kafka liveness probe times out |
| broker.podTemplates.containers.broker.ports | object | `{}` | Ports override for the Apache Kafka container (if set, `containerPorts.*` values will be ignored for this container) |
| broker.podTemplates.containers.broker.readinessProbe.enabled | bool | `true` | Enable readiness probe for Apache Kafka |
| broker.podTemplates.containers.broker.readinessProbe.exec | object | See `values.yaml` | Command to execute for the Apache Kafka startup probe |
| broker.podTemplates.containers.broker.readinessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the Apache Kafka readiness probe to be considered failed after having succeeded |
| broker.podTemplates.containers.broker.readinessProbe.initialDelaySeconds | int | `30` | Number of seconds after the Apache Kafka container has started before readiness probes are initiated |
| broker.podTemplates.containers.broker.readinessProbe.periodSeconds | int | `15` | How often (in seconds) to perform the Apache Kafka readiness probe |
| broker.podTemplates.containers.broker.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the Apache Kafka readiness probe to be considered successful after having failed |
| broker.podTemplates.containers.broker.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the Apache Kafka readiness probe times out |
| broker.podTemplates.containers.broker.resources | object | `{}` | Custom resource requirements for the Apache Kafka container |
| broker.podTemplates.containers.broker.securityContext | object | `{}` | Security context override for the Apache Kafka container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| broker.podTemplates.containers.broker.startupProbe.enabled | bool | `false` | Enable startup probe for Apache Kafka |
| broker.podTemplates.containers.broker.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the Apache Kafka startup probe to be considered failed after having succeeded |
| broker.podTemplates.containers.broker.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the Apache Kafka container has started before startup probes are initiated |
| broker.podTemplates.containers.broker.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the Apache Kafka startup probe |
| broker.podTemplates.containers.broker.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the Apache Kafka startup probe to be considered successful after having failed |
| broker.podTemplates.containers.broker.startupProbe.tcpSocket | object | See `values.yaml` | Port number used to check if the Apache Kafka service is alive |
| broker.podTemplates.containers.broker.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the Apache Kafka startup probe times out |
| broker.podTemplates.containers.broker.volumeMounts | object | See `values.yaml` | Volume mount templates for the Apache Kafka container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| broker.podTemplates.imagePullSecrets | list | `[]` | Custom pull secrets for the Apache Kafka container in the PodTemplate |
| broker.podTemplates.initContainers | object | See `values.yaml` | Init containers to deploy in the Apache Kafka PodTemplate Each field has the init container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| broker.podTemplates.initContainers.volume-permissions.* | string | `nil` | Custom attributes for the Apache Kafka volume-permissions init container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| broker.podTemplates.initContainers.volume-permissions.args | list | `[]` | Arguments override for the Apache Kafka volume-permissions init container entrypoint |
| broker.podTemplates.initContainers.volume-permissions.command | list | See `values.yaml` | Entrypoint override for the Apache Kafka volume-permissions container |
| broker.podTemplates.initContainers.volume-permissions.enabled | bool | `false` | Enable the volume-permissions init container in the Apache Kafka PodTemplate |
| broker.podTemplates.initContainers.volume-permissions.env | object | No environment variables are set | Object with the environment variables templates to use in the Apache Kafka volume-permissions init container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| broker.podTemplates.initContainers.volume-permissions.envFrom | list | `[]` | List of sources from which to populate environment variables to the Apache Kafka volume-permissions init container (e.g. a ConfigMaps or a Secret) |
| broker.podTemplates.initContainers.volume-permissions.image | string | `""` | Image override for the Apache Kafka volume-permissions init container (if set, `images.volume-permissions.{name,tag,digest}` values will be ignored for this container) |
| broker.podTemplates.initContainers.volume-permissions.imagePullPolicy | string | `""` | Image pull policy override for the Apache Kafka volume-permissions init container (if set `images.volume-permissions.pullPolicy` values will be ignored for this container) |
| broker.podTemplates.initContainers.volume-permissions.resources | object | `{}` | Apache Kafka init-containers resource requirements |
| broker.podTemplates.initContainers.volume-permissions.securityContext | object | See `values.yaml` | Security context override for the Apache Kafka volume-permissions init container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| broker.podTemplates.initContainers.volume-permissions.volumeMounts | object | See `values.yaml` | Custom volume mounts for the Apache Kafka volume-permissions init container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| broker.podTemplates.labels | object | `{}` | Labels to add to all pods in the Apache Kafka StatefulSet's PodTemplate |
| broker.podTemplates.securityContext | object | `{}` | Security context override for the pods in the Apache Kafka PodTemplate (if set, `podSecurityContext.*` values will be ignored) |
| broker.podTemplates.serviceAccountName | string | `""` | Service account name override for the pods in the Apache Kafka PodTemplate (if set, `serviceAccount.name` will be ignored) |
| broker.podTemplates.terminationGracePeriodSeconds | int | `120` | Number of seconds prior to the container being forcibly terminated when marked for deletion or restarted. |
| broker.podTemplates.volumes | object | See `values.yaml` | Volume templates for the Apache Kafka PodTemplate, templates are allowed in all fields Each field has the volume name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| broker.secret | object | See `values.yaml` | Secrets to deploy |
| broker.secret.* | string | `nil` | Custom secret to include, templates are allowed both in the secret name and contents |
| broker.secret.enabled | string | `true` if authentication is enabled without existing secret, `false` otherwise | Create a secret for Apache Kafka credentials |
| broker.service.* | string | `nil` | Custom attributes for the Apache Kafka service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| broker.service.annotations | object | `{}` | Custom annotations to add to the service for Apache Kafka |
| broker.service.enabled | bool | `true` | Create a service for Apache Kafka (apart from the headless service) |
| broker.service.nodePorts.* | int32 | `nil` | Service nodePort override for custom Apache Kafka ports specified in `containerPorts.*` |
| broker.service.nodePorts.client | int32 | `""` | Service nodePort override for Apache Kafka client connections |
| broker.service.nodePorts.controller | int32 | `""` | Service nodePort override for Apache Kafka controller connections |
| broker.service.nodePorts.interbroker | int32 | `""` | Service nodePort override for Apache Kafka interbroker connections |
| broker.service.ports.* | int32 | `nil` | Service port override for custom Apache Kafka ports specified in `containerPorts.*` |
| broker.service.ports.client | int32 | `""` | Service port override for Apache Kafka client connections |
| broker.service.ports.controller | int32 | `""` | Apache Kafka port number for controller connections |
| broker.service.ports.interbroker | int32 | `""` | Apache Kafka port number for interbroker connections |
| broker.service.type | string | `"ClusterIP"` | Apache Kafka service type |
| broker.statefulset.* | string | `nil` | Custom attributes for the Apache Kafka StatefulSet (see [`StatefulSetSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/#StatefulSetSpec)) |
| broker.statefulset.enabled | bool | `true` | Enable the StatefulSet template for Apache Kafka standalone brokers |
| broker.statefulset.persistentVolumeClaimRetentionPolicy | object | `{}` | Lifecycle of the persistent volume claims created from Apache Kafka volumeClaimTemplates |
| broker.statefulset.podManagementPolicy | string | `"Parallel"` | How Apache Kafka pods are created during the initial scaleup |
| broker.statefulset.replicas | string | `""` | Desired number of PodTemplate replicas for Apache Kafka broker (overrides `cluster.nodeCount.broker`) |
| broker.statefulset.serviceName | string | `""` | Override for the Apache Kafka' StatefulSet serviceName field, it will be autogenerated if unset |
| broker.statefulset.template | object | `{}` | Template to use for all pods created by the Apache Kafka StatefulSet (overrides `podTemplates.*`) |
| broker.statefulset.updateStrategy | object | See `values.yaml` | Strategy that will be employed to update the pods in the Apache Kafka StatefulSet |
| broker.statefulset.volumeClaimTemplates | object | See `values.yaml` | Volume claim templates for the Apache Kafka statefulset, templates are allowed in all fields Each field has the volumeClaimTemplate name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |

### Override Values

To override a parameter, add *--set* flags to the *helm install* command. For example:

```console
helm install my-release --set images.controller.tag=3.9.0 oci://dp.apps.rancher.io/charts/apache-kafka
```

Alternatively, you can override the parameter values using a custom YAML file with the *-f* flag. For example:

```console
helm install my-release -f custom-values.yaml oci://dp.apps.rancher.io/charts/apache-kafka
```

Read more about [Values files](https://helm.sh/docs/chart_template_guide/values_files/) in the [Helm documentation](https://helm.sh/docs/).

## Missing Features

The following features are acknowledged missing from this Helm chart, and are expected to be added in a future revision:

* Metrics support via JMX Exporter
* Zookeeper mode

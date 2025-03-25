# etcd Helm Chart

> [etcd](https://etcd.io) is a distributed, reliable key-value store for the most critical data of a distributed system.

## Introduction

This Helm chart bootstraps an [etcd](https://etcd.io) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Quick Start

```console
helm install my-release oci://dp.apps.rancher.io/charts/etcd
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
    oci://dp.apps.rancher.io/charts/etcd \
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
| auth.rbac.enabled | bool | `true` | Enable RBAC authentication |
| auth.rbac.existingSecret | string | `""` | Name of a secret containing the credentials for etcd's root user (if set, `auth.rbac.rootPassword` will be ignored) |
| auth.rbac.rootPassword | string | `""` | Password for the etcd `root` user |
| auth.rbac.rootPasswordKey | string | `""` | Root password key in the secret @default `root-password` |
| auth.token.enabled | bool | `true` | Enable token authentication |
| auth.token.existingSecret | string | `""` | Name of a secret containing the private key for signing the etcd token |
| auth.token.privateKeyFilename | string | `"jwt-token.pem"` | Filename of the private key for signing the etcd token in the existing secret |
| auth.token.signMethod | string | `"RS256"` | Method used to sign the token |
| auth.token.ttl | string | `"5m"` |  |
| auth.token.type | string | `"jwt"` | Type of token authentication to enable, valid values: `jwt`, `simple` |
| clusterDomain | string | `"cluster.local"` | Kubernetes cluster domain name |
| commonAnnotations | object | `{}` | Annotations to add to all deployed objects |
| commonLabels | object | `{}` | Labels to add to all deployed objects |
| configMap | object | See `values.yaml` | ConfigMaps to deploy |
| configMap.* | string | `nil` | Custom configuration file to include, templates are allowed both in the config map name and contents |
| configMap.enabled | string | `true` if `configuration` was provided without existing configmap, `false` otherwise | Create a config map for etcd configuration |
| configuration | string | `""` | Contents of etcd configuration file |
| configurationFile | string | `"etcd.conf.yml"` | Configuration file name in the config map |
| containerPorts.* | int32 | `nil` | Custom port number to expose in the etcd containers |
| containerPorts.client | int32 | `2379` | etcd port number for client connections |
| containerPorts.peer | int32 | `2380` | etcd port number for peer connections |
| containerSecurityContext.allowPrivilegeEscalation | bool | `false` | Allow privilege escalation within containers |
| containerSecurityContext.enabled | bool | `true` | Enable container security context |
| containerSecurityContext.runAsNonRoot | bool | `true` | Run containers as a non-root user |
| containerSecurityContext.runAsUser | int | `1000` | Which user ID to run the container as |
| existingConfigMap | string | `""` | Name of an existing config map for etcd configuration |
| extraManifests | list | `[]` | Additional Kubernetes manifests to include in the chart |
| fullnameOverride | string | `""` | Override the resource name |
| global.imagePullSecrets | list | `[]` | Global override for container image registry pull secrets |
| global.imageRegistry | string | `""` | Global override for container image registry |
| global.storageClassName | string | `""` | Global override for the storage class |
| headlessService.* | string | `nil` | Custom attributes for the headless service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| headlessService.annotations | object | `{}` | Custom annotations to add to the headless service for etcd |
| headlessService.clusterIP | string | `"None"` |  |
| headlessService.ports.* | int32 | `nil` | Headless service port override for custom ports specified in `containerPorts.*` |
| headlessService.ports.client | int32 | `""` | Headless service port override for etcd client connections |
| headlessService.ports.peer | int32 | `""` | Headless service port override for etcd peer connections |
| headlessService.publishNotReadyAddresses | bool | `true` | Disregard indications of ready/not-ready The primary use case for setting this field is for a StatefulSet's Headless Service to propagate SRV DNS records for its Pods for the purpose of peer discovery |
| headlessService.type | string | `"ClusterIP"` | Headless service type |
| images.etcd.digest | string | `""` | Image digest to use for the etcd container (if set, `images.etcd.tag` will be ignored) |
| images.etcd.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the etcd container |
| images.etcd.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the etcd container |
| images.etcd.repository | string | `"containers/etcd"` | Image repository to use for the etcd container |
| images.etcd.tag | string | `"3.5.17"` | Image tag to use for the etcd container |
| images.volume-permissions.digest | string | `""` | Image digest to use for the volume permissions init container (if set, `images.volume-permissions.tag` will be ignored) |
| images.volume-permissions.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the volume-permissions container |
| images.volume-permissions.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the volume permissions init container |
| images.volume-permissions.repository | string | `"containers/bci-busybox"` | Image repository to use for the volume permissions init container |
| images.volume-permissions.tag | string | `"15.6"` | Image tag to use for the volume permissions init container |
| initialClusterState | string | `""` | Initial cluster state, valid values: `new`, `existing` |
| initialClusterToken | string | `"etcd-cluster"` | Initial cluster token |
| logLevel | string | `"info"` | Log level |
| metrics.annotations | object | `{"prometheus.io/port":"{{ coalesce .Values.containerPorts.metrics .Values.containerPorts.client }}","prometheus.io/scrape":"true"}` | Annotations to add to all pods that expose metrics |
| metrics.enabled | bool | `false` | Expose etcd metrics |
| metrics.prometheusRule.configuration | object | `{}` | Content of the Prometheus rule file See https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/ |
| metrics.prometheusRule.enabled | bool | `false` | Create a PrometheusRule resource (also requires `metrics.enabled` to be enabled) |
| metrics.prometheusRule.labels | object | `{}` | Additional labels that will be added to the PrometheusRule resource |
| metrics.prometheusRule.namespace | string | `""` | Namespace for the PrometheusRule resource (defaults to the release namespace) |
| nameOverride | string | `""` | Override the resource name prefix (will keep the release name) |
| networkPolicy.allowExternalConnections | bool | `true` | Allow all external connections from and to the pods |
| networkPolicy.egress.allowExternalConnections | bool | `true` | Allow all external egress connections from the pods (requires also `networkPolicy.allowExternalConnections`) |
| networkPolicy.egress.enabled | bool | `true` | Create an egress network policy (requires also `networkPolicy.enabled`) |
| networkPolicy.egress.extraRules | list | `[]` | Custom additional egress rules to enable in the NetworkPolicy resource |
| networkPolicy.egress.namespaceLabels | object | `{}` | List of namespace labels for which to allow egress connections, when external connections are disallowed |
| networkPolicy.egress.podLabels | object | `{}` | List of pod labels for which to allow egress connections, when external connections are disallowed |
| networkPolicy.egress.ports.* | int32 | `nil` | Network policy port override for custom ports specified in `containerPorts.*` for egress connections |
| networkPolicy.egress.ports.client | int32 | `""` | Network policy port override for etcd client connections for egress connections |
| networkPolicy.egress.ports.peer | int32 | `""` | Network policy port override for etcd peer connections for egress connections |
| networkPolicy.enabled | bool | `false` | Create a NetworkPolicy resource |
| networkPolicy.ingress.allowExternalConnections | bool | `true` | Allow all external ingress connections to the pods (requires also `networkPolicy.allowExternalConnections`) |
| networkPolicy.ingress.enabled | bool | `true` | Create an ingress network policy (requires also `networkPolicy.enabled`) |
| networkPolicy.ingress.extraRules | list | `[]` | Custom additional ingress rules to enable in the NetworkPolicy resource |
| networkPolicy.ingress.namespaceLabels | object | `{}` | List of namespace labels for which to allow ingress connections, when external connections are disallowed |
| networkPolicy.ingress.podLabels | object | `{}` | List of pod labels for which to allow ingress connections, when external connections are disallowed |
| networkPolicy.ingress.ports.* | int32 | `nil` | Network policy port override for custom ports specified in `containerPorts.*` for ingress connections |
| networkPolicy.ingress.ports.client | int32 | `""` | Network policy port override for etcd client connections for ingress connections |
| networkPolicy.ingress.ports.peer | int32 | `""` | Network policy port override for etcd peer connections for ingress connections |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Persistent volume access modes |
| persistence.annotations | object | `{}` | Custom annotations to add to the persistent volume claims used by etcd pods |
| persistence.enabled | bool | `true` | Enable persistent volume claims for etcd pods |
| persistence.existingClaim | string | `""` | Name of an existing PersistentVolumeClaim to use by etcd pods |
| persistence.labels | object | `{}` | Custom labels to add to the persistent volume claims used by etcd pods |
| persistence.resources.requests.storage | string | `"8Gi"` | Size of the persistent volume claim to create for etcd pods |
| persistence.storageClassName | string | `""` | Storage class name to use for the etcd persistent volume claim |
| podDisruptionBudget.enabled | bool | `false` | Create a pod disruption budget |
| podDisruptionBudget.maxUnavailable | string | `""` | Number of pods from that can be unavailable after the eviction, this option is mutually exclusive with minAvailable |
| podDisruptionBudget.minAvailable | string | `""` | Number of pods from that set that must still be available after the eviction, this option is mutually exclusive with maxUnavailable |
| podSecurityContext.enabled | bool | `true` | Enable pod security context |
| podSecurityContext.fsGroup | int | `1000` | Group ID that will write to persistent volumes |
| podTemplates.* | string | `nil` | Custom attributes for the pods in the PodTemplate (see [`PodSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec)) |
| podTemplates.annotations | object | `{}` | Annotations to add to all pods in the StatefulSet's PodTemplate |
| podTemplates.containers | object | See `values.yaml` | Containers to deploy in the PodTemplate Each field has the container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| podTemplates.containers.etcd.* | string | `nil` | Custom attributes for the etcd container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| podTemplates.containers.etcd.args | list | `[]` | Arguments override for the etcd container entrypoint |
| podTemplates.containers.etcd.command | list | `["bash","-c","# Ideally we would use a postStart lifecycle hook for this script, but we are skipping it for several reasons:\n# - It is very hard to troubleshoot PostStart hook errors because its logs are not printed anywhere\n# - Related, Container logs cannot be retrieved until the PostStart hook succeeds, because it is stuck at ContainerCreating\n# - Deleting the pods may take a lot of time if the container gets stuck at ContainerCreating\n/mnt/etcd/scripts/etcd-poststart.sh &\n/mnt/etcd/scripts/etcd-entrypoint.sh\n"]` | Entrypoint override for the etcd container |
| podTemplates.containers.etcd.enabled | bool | `true` | Enable the etcd container in the PodTemplate |
| podTemplates.containers.etcd.env | object | See `values.yaml` | Object with the environment variables templates to use in the etcd container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| podTemplates.containers.etcd.envFrom | list | `[]` | List of sources from which to populate environment variables to the etcd container (e.g. a ConfigMaps or a Secret) |
| podTemplates.containers.etcd.image | string | `""` | Image override for the etcd container (if set, `images.etcd.{name,tag,digest}` values will be ignored for this container) |
| podTemplates.containers.etcd.imagePullPolicy | string | `""` | Image pull policy override for the etcd container (if set `images.etcd.pullPolicy` values will be ignored for this container) |
| podTemplates.containers.etcd.livenessProbe.enabled | bool | `true` | Enable liveness probe for etcd |
| podTemplates.containers.etcd.livenessProbe.exec | object | `{"command":["/mnt/etcd/scripts/etcd-healthcheck.sh"]}` | Command to execute for the startup probe |
| podTemplates.containers.etcd.livenessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the liveness probe to be considered failed after having succeeded |
| podTemplates.containers.etcd.livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before liveness probes are initiated |
| podTemplates.containers.etcd.livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the liveness probe |
| podTemplates.containers.etcd.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the liveness probe to be considered successful after having failed |
| podTemplates.containers.etcd.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the liveness probe times out |
| podTemplates.containers.etcd.ports | object | `{}` | Ports override for the etcd container (if set, `containerPorts.*` values will be ignored for this container) |
| podTemplates.containers.etcd.readinessProbe.enabled | bool | `true` | Enable readiness probe for etcd |
| podTemplates.containers.etcd.readinessProbe.exec | object | `{"command":["/mnt/etcd/scripts/etcd-healthcheck.sh"]}` | Command to execute for the startup probe |
| podTemplates.containers.etcd.readinessProbe.failureThreshold | int | `5` | Minimum consecutive failures for the readiness probe to be considered failed after having succeeded |
| podTemplates.containers.etcd.readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before readiness probes are initiated |
| podTemplates.containers.etcd.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the readiness probe |
| podTemplates.containers.etcd.readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the readiness probe to be considered successful after having failed |
| podTemplates.containers.etcd.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the readiness probe times out |
| podTemplates.containers.etcd.resources | object | `{}` | Custom resource requirements for the etcd container |
| podTemplates.containers.etcd.securityContext | object | `{}` | Security context override for the etcd container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| podTemplates.containers.etcd.startupProbe.enabled | bool | `false` | Enable startup probe for etcd |
| podTemplates.containers.etcd.startupProbe.exec | object | `{"command":["/mnt/etcd/scripts/etcd-healthcheck.sh"]}` | Command to execute for the startup probe |
| podTemplates.containers.etcd.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the startup probe to be considered failed after having succeeded |
| podTemplates.containers.etcd.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before startup probes are initiated |
| podTemplates.containers.etcd.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the startup probe |
| podTemplates.containers.etcd.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the startup probe to be considered successful after having failed |
| podTemplates.containers.etcd.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the startup probe times out |
| podTemplates.containers.etcd.volumeMounts | object | See `values.yaml` | Volume mount templates for the etcd container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| podTemplates.imagePullSecrets | list | `[]` | Custom pull secrets for the etcd container in the PodTemplate |
| podTemplates.initContainers | object | See `values.yaml` | Init containers to deploy in the PodTemplate Each field has the init container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it |
| podTemplates.initContainers.volume-permissions.* | string | `nil` | Custom attributes for the volume-permissions init container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container)) |
| podTemplates.initContainers.volume-permissions.args | list | `[]` | Arguments override for the volume-permissions init container entrypoint |
| podTemplates.initContainers.volume-permissions.command | list | `["/bin/sh","-ec","chown -R {{ .Values.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }} /mnt/etcd/data\n"]` | Entrypoint override for the volume-permissions container |
| podTemplates.initContainers.volume-permissions.enabled | bool | `false` | Enable the volume-permissions init container in the PodTemplate |
| podTemplates.initContainers.volume-permissions.env | object | No environment variables are set | Object with the environment variables templates to use in the volume-permissions init container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it |
| podTemplates.initContainers.volume-permissions.envFrom | list | `[]` | List of sources from which to populate environment variables to the volume-permissions init container (e.g. a ConfigMaps or a Secret) |
| podTemplates.initContainers.volume-permissions.image | string | `""` | Image override for the volume-permissions init container (if set, `images.volume-permissions.{name,tag,digest}` values will be ignored for this container) |
| podTemplates.initContainers.volume-permissions.imagePullPolicy | string | `""` | Image pull policy override for the volume-permissions init container (if set `images.volume-permissions.pullPolicy` values will be ignored for this container) |
| podTemplates.initContainers.volume-permissions.resources | object | `{}` | Containers resource requirements |
| podTemplates.initContainers.volume-permissions.securityContext | object | `{"runAsUser":0}` | Security context override for the volume-permissions init container (if set, `containerSecurityContext.*` values will be ignored for this container) |
| podTemplates.initContainers.volume-permissions.volumeMounts | object | See `values.yaml` | Custom volume mounts for the volume-permissions init container, templates are allowed in all fields Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| podTemplates.labels | object | `{}` | Labels to add to all pods in the StatefulSet's PodTemplate |
| podTemplates.securityContext | object | `{}` | Security context override for the pods in the PodTemplate (if set, `podSecurityContext.*` values will be ignored) |
| podTemplates.serviceAccountName | string | `""` | Service account name override for the pods in the PodTemplate (if set, `serviceAccount.name` will be ignored) |
| podTemplates.volumes | object | See `values.yaml` | Volume templates for the PodTemplate, templates are allowed in all fields Each field has the volume name as key, and a YAML string template with the values; you must set `enabled: true` to enable it |
| replicaCount | int | `1` | Desired number of PodTemplate replicas |
| secret | object | See `values.yaml` | Secrets to deploy |
| secret.* | string | `nil` | Custom secret to include, templates are allowed both in the secret name and contents |
| secret.enabled | string | `true` if RBAC is enabled without existing secret, `false` otherwise | Create a secret for etcd credentials |
| service.* | string | `nil` | Custom attributes for the service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec)) |
| service.annotations | object | `{}` | Custom annotations to add to the service for etcd |
| service.enabled | bool | `true` | Create a service for etcd (apart from the headless service) |
| service.nodePorts.* | int32 | `nil` | Service nodePort override for custom ports specified in `containerPorts.*` |
| service.nodePorts.client | int32 | `""` | Service nodePort override for etcd client connections |
| service.nodePorts.peer | int32 | `""` | Service nodePort override for etcd peer connections |
| service.ports.* | int32 | `nil` | Service port override for custom ports specified in `containerPorts.*` |
| service.ports.client | int32 | `""` | Service port override for etcd client connections |
| service.ports.peer | int32 | `""` | Service port override for etcd peer connections |
| service.type | string | `"ClusterIP"` | Service type |
| serviceAccount.annotations | object | `{}` | Add custom annotations to the ServiceAccount |
| serviceAccount.automountServiceAccountToken | bool | `true` | Whether pods running as this service account should have an API token automatically mounted |
| serviceAccount.enabled | bool | `false` | Create or use an existing service account |
| serviceAccount.imagePullSecrets | list | `[]` | List of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount |
| serviceAccount.labels | object | `{}` | Add custom labels to the ServiceAccount |
| serviceAccount.name | string | `""` | Name of the ServiceAccount to use |
| serviceAccount.secrets | list | `[]` | List of secrets in the same namespace that pods running using this ServiceAccount are allowed to use |
| statefulset.* | string | `nil` | Custom attributes for the StatefulSet (see [`StatefulSetSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/#StatefulSetSpec)) |
| statefulset.enabled | bool | `true` | Enable the StatefulSet template |
| statefulset.persistentVolumeClaimRetentionPolicy | object | `{}` | Lifecycle of the persistent volume claims created from volumeClaimTemplates |
| statefulset.podManagementPolicy | string | `"Parallel"` | How pods are created during the initial scaleup |
| statefulset.replicas | string | `""` | Desired number of PodTemplate replicas (overrides `replicaCount`) |
| statefulset.serviceName | string | `""` | Override for the StatefulSet's serviceName field, it will be autogenerated if unset |
| statefulset.template | object | `{}` | Template to use for all pods created by the StatefulSet (overrides `podTemplates.*`) |
| statefulset.updateStrategy | object | `{"type":"RollingUpdate"}` | Strategy that will be employed to update the pods in the StatefulSet |
| transportSecurity.client.certAllowedHostname | string | `""` | Allowed TLS hostname for client cert authentication |
| transportSecurity.client.certFilename | string | `"cert.pem"` | Filename of the client certificate file in the existing secret |
| transportSecurity.client.clientCertAuth | bool | `false` | Check all client requests for valid client certificates signed by the supplied CA |
| transportSecurity.client.crlFilename | string | `""` | Filename of the client certificate revocation list file in the existing secret |
| transportSecurity.client.enableAutoTLS | bool | `false` | Enable Auto-TLS certificate generation for etcd client connections |
| transportSecurity.client.enabled | bool | `false` | Enable client-to-server transport security (requires `transportSecurity.client.existingSecret`) |
| transportSecurity.client.existingSecret | string | `""` | Name of the secret containing the etcd client certificate for client connections |
| transportSecurity.client.keyFilename | string | `"key.pem"` | Filename of the client certificate key file in the existing secret |
| transportSecurity.client.trustedCAFilename | string | `""` | Filename of the client server TLS trusted CA cert file in the existing secret |
| transportSecurity.peer.certAllowedCN | string | `""` | Required CN for client certs connecting to the peer endpoint |
| transportSecurity.peer.certAllowedHostname | string | `""` | Allowed TLS hostname for peer cert authentication |
| transportSecurity.peer.certFilename | string | `""` | Filename of the peer certificate file in the existing secret |
| transportSecurity.peer.clientCertAuth | bool | `false` | Check all peer requests for valid client certificates signed by the supplied CA |
| transportSecurity.peer.crlFilename | string | `""` | Filename of the peer certificate revocation list file in the existing secret |
| transportSecurity.peer.enableAutoTLS | bool | `false` | Enable Auto-TLS certificate generation for etcd peer connections |
| transportSecurity.peer.enabled | bool | `false` | Enable transport security in the cluster (requires `transportSecurity.peer.existingSecret`) |
| transportSecurity.peer.existingSecret | string | `""` | Name of the secret containing the etcd client certificate for peer connections |
| transportSecurity.peer.keyFilename | string | `""` | Filename of the peer certificate key file in the existing secret |
| transportSecurity.peer.trustedCAFilename | string | `""` | Filename of the peer server TLS trusted CA cert file in the existing secret |

### Override Values

To override a parameter, add *--set* flags to the *helm install* command. For example:

```console
helm install my-release --set images.etcd.tag=3.5.17 oci://dp.apps.rancher.io/charts/etcd
```

Alternatively, you can override the parameter values using a custom YAML file with the *-f* flag. For example:

```console
helm install my-release -f custom-values.yaml oci://dp.apps.rancher.io/charts/etcd
```

Read more about [Values files](https://helm.sh/docs/chart_template_guide/values_files/) in the [Helm documentation](https://helm.sh/docs/).

## Missing Features

The following features are acknowledged missing from this Helm chart, and are expected to be added in a future revision:

* Snapshot creation of backup data.
* Disaster recovery of the backup data, in case of a majority failure due to lack of quorum.

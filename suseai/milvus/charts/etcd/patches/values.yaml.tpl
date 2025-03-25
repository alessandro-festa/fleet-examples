global:
  # -- Global override for the storage class
  storageClassName: ""
  # -- Global override for container image registry
  imageRegistry: ""
  # -- Global override for container image registry pull secrets
  imagePullSecrets: []

# -- Annotations to add to all deployed objects
commonAnnotations: {}
# -- Labels to add to all deployed objects
commonLabels: {}
# -- Override the resource name
fullnameOverride: ""
# -- Override the resource name prefix (will keep the release name)
nameOverride: ""
# -- Additional Kubernetes manifests to include in the chart
extraManifests: []
# -- Kubernetes cluster domain name
clusterDomain: cluster.local
# -- Desired number of PodTemplate replicas
replicaCount: 1

auth:
  rbac:
    # -- Enable RBAC authentication
    enabled: true
    # -- Password for the etcd `root` user
    rootPassword: ""
    # -- Name of a secret containing the credentials for etcd's root user (if set, `auth.rbac.rootPassword` will be ignored)
    existingSecret: ""
    # -- Root password key in the secret
    # @default `root-password`
    rootPasswordKey: ""
  token:
    # -- Enable token authentication
    enabled: true
    # -- Type of token authentication to enable, valid values: `jwt`, `simple`
    type: jwt
    # -- Method used to sign the token
    signMethod: RS256
    # How long the token will be valid for
    ttl: 5m
    # -- Name of a secret containing the private key for signing the etcd token
    existingSecret: ""
    # -- Filename of the private key for signing the etcd token in the existing secret
    privateKeyFilename: jwt-token.pem
transportSecurity:
  client:
    # -- Enable client-to-server transport security (requires `transportSecurity.client.existingSecret`)
    enabled: false
    # -- Check all client requests for valid client certificates signed by the supplied CA
    clientCertAuth: false
    # -- Enable Auto-TLS certificate generation for etcd client connections
    enableAutoTLS: false
    # -- Allowed TLS hostname for client cert authentication
    certAllowedHostname: ""
    # -- Name of the secret containing the etcd client certificate for client connections
    existingSecret: ""
    # -- Filename of the client certificate file in the existing secret
    certFilename: cert.pem
    # -- Filename of the client certificate key file in the existing secret
    keyFilename: key.pem
    # -- Filename of the client certificate revocation list file in the existing secret
    crlFilename: ""
    # -- Filename of the client server TLS trusted CA cert file in the existing secret
    trustedCAFilename: ""
  peer:
    # -- Enable transport security in the cluster (requires `transportSecurity.peer.existingSecret`)
    enabled: false
    # -- Check all peer requests for valid client certificates signed by the supplied CA
    clientCertAuth: false
    # -- Enable Auto-TLS certificate generation for etcd peer connections
    enableAutoTLS: false
    # -- Allowed TLS hostname for peer cert authentication
    certAllowedHostname: ""
    # -- Required CN for client certs connecting to the peer endpoint
    certAllowedCN: ""
    # -- Name of the secret containing the etcd client certificate for peer connections
    existingSecret: ""
    # -- Filename of the peer certificate file in the existing secret
    certFilename: ""
    # -- Filename of the peer certificate key file in the existing secret
    keyFilename: ""
    # -- Filename of the peer certificate revocation list file in the existing secret
    crlFilename: ""
    # -- Filename of the peer server TLS trusted CA cert file in the existing secret
    trustedCAFilename: ""
# -- Configuration file name in the config map
configurationFile: etcd.conf.yml
# -- Contents of etcd configuration file
configuration: ""
# -- Name of an existing config map for etcd configuration
existingConfigMap: ""
# -- Initial cluster state, valid values: `new`, `existing`
initialClusterState: ""
# -- Initial cluster token
initialClusterToken: etcd-cluster
# -- Log level
logLevel: info
persistence:
  # -- Enable persistent volume claims for etcd pods
  enabled: true
  # -- Custom annotations to add to the persistent volume claims used by etcd pods
  annotations: {}
  # -- Custom labels to add to the persistent volume claims used by etcd pods
  labels: {}
  # -- Name of an existing PersistentVolumeClaim to use by etcd pods
  existingClaim: ""
  # -- Persistent volume access modes
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      # -- Size of the persistent volume claim to create for etcd pods
      storage: 8Gi
  # -- Storage class name to use for the etcd persistent volume claim
  storageClassName: ""

containerPorts:
  # -- (int32) etcd port number for client connections
  client: 2379
  # -- (int32) etcd port number for peer connections
  peer: 2380
  # -- (int32) Custom port number to expose in the etcd containers
  "*":
  # Note: This field is only added for documentation purposes

images:
  etcd:
    # -- Image registry to use for the etcd container
    registry: ${CONTAINER_REGISTRY}
    # -- Image repository to use for the etcd container
    repository: containers/etcd
    # -- Image tag to use for the etcd container
    tag: ${APP_VERSION}
    # -- Image digest to use for the etcd container (if set, `images.etcd.tag` will be ignored)
    digest: ""
    # -- Image pull policy to use for the etcd container
    pullPolicy: IfNotPresent
  volume-permissions:
    # -- Image registry to use for the volume permissions init container
    registry: ${CONTAINER_REGISTRY}
    # -- Image repository to use for the volume permissions init container
    repository: containers/bci-busybox
    # -- Image tag to use for the volume permissions init container
    tag: "15.6"
    # -- Image digest to use for the volume permissions init container (if set, `images.volume-permissions.tag` will be ignored)
    digest: ""
    # -- Image pull policy to use for the volume-permissions container
    pullPolicy: IfNotPresent

# -- ConfigMaps to deploy
# @default -- See `values.yaml`
configMap:
  # -- Create a config map for etcd configuration
  # @default -- `true` if `configuration` was provided without existing configmap, `false` otherwise
  enabled: '{{ and (not .Values.existingConfigMap) (not (empty .Values.configuration)) }}'
  # See: https://github.com/etcd-io/etcd/blob/main/etcd.conf.yml.sample
  '{{ .Values.configurationFile }}': '{{ .Values.configuration }}'
  # -- (string) Custom configuration file to include, templates are allowed both in the config map name and contents
  "*":
  # Note: This field is only added for documentation purposes

# -- Secrets to deploy
# @default -- See `values.yaml`
secret:
  # -- Create a secret for etcd credentials
  # @default -- `true` if RBAC is enabled without existing secret, `false` otherwise
  enabled: '{{ and (eq (include "auth.rbac.enabled" .) "true") (not .Values.auth.rbac.existingSecret) }}'
  '{{ include "auth.rbac.rootPasswordKey" . }}': '{{ default (randAscii 16) .Values.auth.rbac.rootPassword }}'
  # -- (string) Custom secret to include, templates are allowed both in the secret name and contents
  "*":
  # Note: This field is only added for documentation purposes

statefulset:
  # -- Enable the StatefulSet template
  enabled: true
  # -- Override for the StatefulSet's serviceName field, it will be autogenerated if unset
  serviceName: ""
  # -- Template to use for all pods created by the StatefulSet (overrides `podTemplates.*`)
  template: {}
  # -- Desired number of PodTemplate replicas (overrides `replicaCount`)
  replicas: ""
  # -- Strategy that will be employed to update the pods in the StatefulSet
  updateStrategy:
    type: RollingUpdate
  # -- How pods are created during the initial scaleup
  podManagementPolicy: Parallel
  # -- Lifecycle of the persistent volume claims created from volumeClaimTemplates
  persistentVolumeClaimRetentionPolicy: {}
  #  whenScaled: Retain
  #  whenDeleted: Retain
  # -- Custom attributes for the StatefulSet (see [`StatefulSetSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/stateful-set-v1/#StatefulSetSpec))
  "*":
  # Note: This field is only added for documentation purposes

podTemplates:
  # -- Annotations to add to all pods in the StatefulSet's PodTemplate
  annotations: {}
  # -- Labels to add to all pods in the StatefulSet's PodTemplate
  labels: {}
  # -- Init containers to deploy in the PodTemplate
  # @default -- See `values.yaml`
  # Each field has the init container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it
  initContainers:
    volume-permissions:
      # -- Enable the volume-permissions init container in the PodTemplate
      enabled: false
      # -- Image override for the volume-permissions init container (if set, `images.volume-permissions.{name,tag,digest}` values will be ignored for this container)
      image: ""
      # -- Image pull policy override for the volume-permissions init container (if set `images.volume-permissions.pullPolicy` values will be ignored for this container)
      imagePullPolicy: ""
      # -- Entrypoint override for the volume-permissions container
      command:
        - /bin/sh
        - -ec
        - |
          chown -R {{ .Values.containerSecurityContext.runAsUser }}:{{ .Values.podSecurityContext.fsGroup }} /mnt/etcd/data
      # -- Arguments override for the volume-permissions init container entrypoint
      args: []
      # -- Object with the environment variables templates to use in the volume-permissions init container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it
      # @default -- No environment variables are set
      env: {}
      # -- List of sources from which to populate environment variables to the volume-permissions init container (e.g. a ConfigMaps or a Secret)
      envFrom: []
      # -- Custom volume mounts for the volume-permissions init container, templates are allowed in all fields
      # @default -- See `values.yaml`
      # Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it
      volumeMounts:
        data:
          enabled: true
          mountPath: /mnt/etcd/data
      # -- Containers resource requirements
      resources: {}
      # We usually recommend not to specify default resources and to leave this as a conscious
      # choice for the user. This also increases chances charts run on environments with little
      # resources, such as Minikube. If you do want to specify resources, uncomment the following
      # lines, adjust them as necessary, and remove the curly braces after 'resources:'
      #   limits:
      #    cpu: 100m
      #    memory: 128Mi
      #   requests:
      #    cpu: 100m
      #    memory: 128Mi
      # -- Security context override for the volume-permissions init container (if set, `containerSecurityContext.*` values will be ignored for this container)
      securityContext:
        runAsUser: 0
      # -- Custom attributes for the volume-permissions init container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container))
      "*":
      # Note: This field is only added for documentation purposes
  # -- Containers to deploy in the PodTemplate
  # @default -- See `values.yaml`
  # Each field has the container name as key, and a YAML object template with the values; you must set `enabled: true` to enable it
  containers:
    etcd:
      # -- Enable the etcd container in the PodTemplate
      enabled: true
      # -- Image override for the etcd container (if set, `images.etcd.{name,tag,digest}` values will be ignored for this container)
      image: ""
      # -- Image pull policy override for the etcd container (if set `images.etcd.pullPolicy` values will be ignored for this container)
      imagePullPolicy: ""
      # -- Entrypoint override for the etcd container
      command:
        - bash
        - -c
        - |
          # Ideally we would use a postStart lifecycle hook for this script, but we are skipping it for several reasons:
          # - It is very hard to troubleshoot PostStart hook errors because its logs are not printed anywhere
          # - Related, Container logs cannot be retrieved until the PostStart hook succeeds, because it is stuck at ContainerCreating
          # - Deleting the pods may take a lot of time if the container gets stuck at ContainerCreating
          /mnt/etcd/scripts/etcd-poststart.sh &
          /mnt/etcd/scripts/etcd-entrypoint.sh
      # -- Arguments override for the etcd container entrypoint
      args: []
      # -- Ports override for the etcd container (if set, `containerPorts.*` values will be ignored for this container)
      ports: {}
      # -- Object with the environment variables templates to use in the etcd container, the values can be specified as an object or a string; when using objects you must also set `enabled: true` to enable it
      # @default -- See `values.yaml`
      env:
        POD_NAME:
          enabled: true
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
        # Find all available configuration options in the official documentation
        # https://etcd.io/docs/latest/op-guide/configuration/
        ETCD_CONFIG_FILE:
          enabled: '{{ tpl .Values.configMap.enabled $ }}'
          value: '/mnt/etcd/conf/{{ .Values.configurationFile }}'
        ETCD_NAME: '$(POD_NAME)'
        ETCD_DATA_DIR: /mnt/etcd/data/default.etcd
        ETCD_LISTEN_PEER_URLS: '{{ printf "%s://%s:%d" (include "peerProtocol" $) "0.0.0.0" (int .Values.containerPorts.peer) }}'
        ETCD_LISTEN_CLIENT_URLS: '{{ printf "%s://%s:%d" (include "clientProtocol" $) "0.0.0.0" (int .Values.containerPorts.client) }}'
        ETCD_INITIAL_ADVERTISE_PEER_URLS: '{{ printf "%s://%s.%s.%s.svc.%s:%d" (include "peerProtocol" $) "$(POD_NAME)" (include "fullName" (dict "suffix" "headless" "context" $)) .Release.Namespace .Values.clusterDomain (int .Values.containerPorts.peer) }}'
        ETCD_ADVERTISE_CLIENT_URLS: '{{ printf "%s://%s.%s.%s.svc.%s:%d" (include "clientProtocol" $) "$(POD_NAME)" (include "fullName" (dict "suffix" "headless" "context" $)) .Release.Namespace .Values.clusterDomain (int .Values.containerPorts.client) }}'
        ETCD_INITIAL_CLUSTER:
          enabled: '{{ gt (int .Values.statefulset.replicas) 1 }}'
          value: '{{ include "initialCluster" $ }}'
        ETCD_INITIAL_CLUSTER_TOKEN:
          enabled: '{{ gt (int .Values.statefulset.replicas) 1 }}'
          value: '{{ .Values.initialClusterToken }}'
        ETCD_INITIAL_CLUSTER_STATE:
          enabled: '{{ gt (int .Values.statefulset.replicas) 1 }}'
          value: '{{ coalesce .Values.initialClusterState (ternary "new" "existing" .Release.IsInstall) }}'
        ETCD_LOG_LEVEL: '{{ .Values.logLevel }}'
        ETCD_AUTH_TOKEN:
          enabled: '{{ .Values.auth.token.enabled }}'
          value: '{{ if eq .Values.auth.token.type "simple" }}simple{{ else }}{{ printf "jwt,priv-key=%s/%s,sign-method=%s,ttl=%s" "/mnt/etcd/certs/token" .Values.auth.token.privateKeyFilename .Values.auth.token.signMethod .Values.auth.token.ttl }}{{ end }}'
        # Transport security for client connections
        ETCD_CERT_FILE:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.certFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.certFilename }}'
        ETCD_KEY_FILE:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.keyFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.keyFilename }}'
        ETCD_CLIENT_CERT_AUTH:
          enabled: '{{ and .Values.transportSecurity.client.enabled .Values.transportSecurity.client.clientCertAuth }}'
          value: '{{ .Values.transportSecurity.client.clientCertAuth }}'
        ETCD_CLIENT_CRL_FILE:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.crlFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.crlFilename }}'
        ETCD_CLIENT_CERT_ALLOWED_HOSTNAME:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.certAllowedHostname)) }}'
          value: '{{ .Values.transportSecurity.client.certAllowedHostname }}'
        ETCD_TRUSTED_CA_FILE:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.trustedCAFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.trustedCAFilename }}'
        ETCD_AUTO_TLS:
          enabled: '{{ and .Values.transportSecurity.client.enabled .Values.transportSecurity.client.enableAutoTLS }}'
          value: '{{ .Values.transportSecurity.client.enableAutoTLS }}'
        # Transport security for client connections
        ETCD_PEER_CERT_FILE:
          enabled: '{{ and .Values.transportSecurity.peer.enabled (not (empty .Values.transportSecurity.peer.certFilename)) }}'
          value: '/mnt/etcd/certs/peer/{{ .Values.transportSecurity.peer.certFilename }}'
        ETCD_PEER_KEY_FILE:
          enabled: '{{ and .Values.transportSecurity.peer.enabled (not (empty .Values.transportSecurity.peer.keyFilename)) }}'
          value: '/mnt/etcd/certs/peer/{{ .Values.transportSecurity.peer.keyFilename }}'
        ETCD_PEER_CLIENT_CERT_AUTH:
          enabled: '{{ and .Values.transportSecurity.peer.enabled .Values.transportSecurity.peer.clientCertAuth }}'
          value: '{{ .Values.transportSecurity.peer.clientCertAuth }}'
        ETCD_PEER_CRL_FILE:
          enabled: '{{ and .Values.transportSecurity.peer.enabled (not (empty .Values.transportSecurity.peer.crlFilename)) }}'
          value: '/mnt/etcd/certs/peer/{{ .Values.transportSecurity.peer.crlFilename }}'
        ETCD_PEER_CERT_ALLOWED_CN:
          enabled: '{{ and .Values.transportSecurity.peer.enabled (not (empty .Values.transportSecurity.peer.certAllowedCN)) }}'
          value: '{{ .Values.transportSecurity.peer.certAllowedCN }}'
        ETCD_PEER_CERT_ALLOWED_HOSTNAME:
          enabled: '{{ and .Values.transportSecurity.peer.enabled (not (empty .Values.transportSecurity.peer.certAllowedHostname)) }}'
          value: '{{ .Values.transportSecurity.peer.certAllowedHostname }}'
        ETCD_PEER_TRUSTED_CA_FILE:
          enabled: '{{ and .Values.transportSecurity.peer.enabled (not (empty .Values.transportSecurity.peer.trustedCAFilename)) }}'
          value: '/mnt/etcd/certs/peer/{{ .Values.transportSecurity.peer.trustedCAFilename }}'
        ETCD_PEER_AUTO_TLS:
          enabled: '{{ and .Values.transportSecurity.peer.enabled .Values.transportSecurity.peer.enableAutoTLS }}'
          value: '{{ .Values.transportSecurity.peer.enableAutoTLS }}'
        # Configurations for etcdctl CLI
        ETCDCTL_API: "3"
        ETCDCTL_ENDPOINTS: '{{ include "endpoints" $ }}'
        ETCDCTL_CACERT:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.trustedCAFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.trustedCAFilename }}'
        ETCDCTL_CERT:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.certFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.certFilename }}'
        ETCDCTL_KEY:
          enabled: '{{ and .Values.transportSecurity.client.enabled (not (empty .Values.transportSecurity.client.keyFilename)) }}'
          value: '/mnt/etcd/certs/client/{{ .Values.transportSecurity.client.keyFilename }}'
        ETCDCTL_USER:
          enabled: '{{ include "auth.rbac.enabled" . }}'
          value: root
        ETCDCTL_PASSWORD:
          enabled: '{{ include "auth.rbac.enabled" . }}'
          value: $(_ETCD_ROOT_PASSWORD)
        # Environment variables used as placeholders or by initialization scripts
        _ETCD_ROOT_PASSWORD:
          enabled: '{{ include "auth.rbac.enabled" . }}'
          valueFrom:
            secretKeyRef:
              name: '{{ coalesce .Values.auth.rbac.existingSecret (include "fullName" $) }}'
              key: '{{ include "auth.rbac.rootPasswordKey" . }}'
      # -- List of sources from which to populate environment variables to the etcd container (e.g. a ConfigMaps or a Secret)
      envFrom: []
      # -- Volume mount templates for the etcd container, templates are allowed in all fields
      # @default -- See `values.yaml`
      # Each field has the volume mount name as key, and a YAML string template with the values; you must set `enabled: true` to enable it
      volumeMounts:
        conf:
          enabled: '{{ and (not .Values.existingConfigMap) .Values.configuration }}'
          mountPath: /mnt/etcd/conf
          readOnly: true
        data:
          enabled: true
          mountPath: /mnt/etcd/data
        scripts:
          enabled: true
          mountPath: /mnt/etcd/scripts
          readOnly: true
        certs-client:
          enabled: '{{ .Values.transportSecurity.client.enabled }}'
          mountPath: /mnt/etcd/certs/client
          readOnly: true
        certs-peer:
          enabled: '{{ .Values.transportSecurity.peer.enabled }}'
          mountPath: /mnt/etcd/certs/peer
          readOnly: true
        certs-jwt-token:
          enabled: '{{ and .Values.auth.token.enabled (eq .Values.auth.token.type "jwt") }}'
          mountPath: /mnt/etcd/certs/token
          readOnly: true
      # -- Custom resource requirements for the etcd container
      resources: {}
      # We usually recommend not to specify default resources and to leave this as a conscious
      # choice for the user. This also increases chances charts run on environments with little
      # resources, such as Minikube. If you do want to specify resources, uncomment the following
      # lines, adjust them as necessary, and remove the curly braces after 'resources:'
      #   limits:
      #    cpu: 100m
      #    memory: 128Mi
      #   requests:
      #    cpu: 100m
      #    memory: 128Mi
      # -- Security context override for the etcd container (if set, `containerSecurityContext.*` values will be ignored for this container)
      securityContext: {}
      livenessProbe:
        # -- Enable liveness probe for etcd
        enabled: true
        # -- Command to execute for the startup probe
        exec:
          command:
            - /mnt/etcd/scripts/etcd-healthcheck.sh
        # -- Number of seconds after the container has started before liveness probes are initiated
        initialDelaySeconds: 10
        # -- How often (in seconds) to perform the liveness probe
        periodSeconds: 10
        # -- Number of seconds after which the liveness probe times out
        timeoutSeconds: 5
        # -- Minimum consecutive failures for the liveness probe to be considered failed after having succeeded
        failureThreshold: 5
        # -- Minimum consecutive successes for the liveness probe to be considered successful after having failed
        successThreshold: 1
      readinessProbe:
        # -- Enable readiness probe for etcd
        enabled: true
        # -- Command to execute for the startup probe
        exec:
          command:
            - /mnt/etcd/scripts/etcd-healthcheck.sh
        # -- Number of seconds after the container has started before readiness probes are initiated
        initialDelaySeconds: 10
        # -- How often (in seconds) to perform the readiness probe
        periodSeconds: 10
        # -- Number of seconds after which the readiness probe times out
        timeoutSeconds: 5
        # -- Minimum consecutive failures for the readiness probe to be considered failed after having succeeded
        failureThreshold: 5
        # -- Minimum consecutive successes for the readiness probe to be considered successful after having failed
        successThreshold: 1
      startupProbe:
        # -- Enable startup probe for etcd
        enabled: false
        # -- Command to execute for the startup probe
        exec:
          command:
            - /mnt/etcd/scripts/etcd-healthcheck.sh
        # -- Number of seconds after the container has started before startup probes are initiated
        initialDelaySeconds: 0
        # -- How often (in seconds) to perform the startup probe
        periodSeconds: 10
        # -- Number of seconds after which the startup probe times out
        timeoutSeconds: 5
        # -- Minimum consecutive failures for the startup probe to be considered failed after having succeeded
        failureThreshold: 10
        # -- Minimum consecutive successes for the startup probe to be considered successful after having failed
        successThreshold: 1
      # -- Custom attributes for the etcd container (see [`Container` API spec](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#Container))
      "*":
      # Note: This field is only added for documentation purposes
  # -- Custom pull secrets for the etcd container in the PodTemplate
  imagePullSecrets: []
  # -- Volume templates for the PodTemplate, templates are allowed in all fields
  # @default -- See `values.yaml`
  # Each field has the volume name as key, and a YAML string template with the values; you must set `enabled: true` to enable it
  volumes:
    conf:
      enabled: '{{ and (not .Values.existingConfigMap) .Values.configuration }}'
      configMap:
        name: '{{ include "fullName" (dict "suffix" "configuration" "context" $) }}'
        defaultMode: 0o400
    data:
      enabled: '{{ and (not .Values.statefulset.volumeClaimTemplates) (not .Values.persistence.enabled) }}'
      emptyDir:
        medium: ""
    scripts:
      enabled: true
      configMap:
        name: '{{ include "fullName" (dict "suffix" "scripts" "context" $) }}'
        defaultMode: 0o550
    certs-client:
      enabled: '{{ .Values.transportSecurity.client.enabled }}'
      secret:
        secretName: '{{ tpl .Values.transportSecurity.client.existingSecret . }}'
        defaultMode: 0o400
    certs-peer:
      enabled: '{{ .Values.transportSecurity.peer.enabled }}'
      secret:
        secretName: '{{ tpl .Values.transportSecurity.peer.existingSecret . }}'
        defaultMode: 0o400
    certs-jwt-token:
      enabled: '{{ and .Values.auth.token.enabled (eq .Values.auth.token.type "jwt") }}'
      secret:
        secretName: '{{ coalesce (tpl .Values.auth.token.existingSecret $) (include "fullName" (dict "suffix" "jwt-token" "context" $)) }}'
        defaultMode: 0o400
  # -- Service account name override for the pods in the PodTemplate (if set, `serviceAccount.name` will be ignored)
  serviceAccountName: ""
  # -- Security context override for the pods in the PodTemplate (if set, `podSecurityContext.*` values will be ignored)
  securityContext: {}
  # -- Custom attributes for the pods in the PodTemplate (see [`PodSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#PodSpec))
  "*":
  # Note: This field is only added for documentation purposes

podSecurityContext:
  # -- Enable pod security context
  enabled: true
  # -- Group ID that will write to persistent volumes
  fsGroup: 1000

containerSecurityContext:
  # -- Enable container security context
  enabled: true
  # -- Allow privilege escalation within containers
  allowPrivilegeEscalation: false
  # -- Run containers as a non-root user
  runAsNonRoot: true
  # -- Which user ID to run the container as
  runAsUser: 1000

metrics:
  # -- Expose etcd metrics
  enabled: false
  # -- Annotations to add to all pods that expose metrics
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: '{{ coalesce .Values.containerPorts.metrics .Values.containerPorts.client }}'
  prometheusRule:
    # -- Content of the Prometheus rule file
    # See https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/
    configuration: {}
    # Example Prometheus rule file copied from https://github.com/etcd-io/etcd/tree/main/contrib/mixin:
    #   groups:
    #     - name: etcd
    #       rules:
    #         # ...
    #         - alert: etcdInsufficientMembers
    #             annotations:
    #               description: 'etcd cluster "{{ $labels.job }}": insufficient members ({{ $value }}).'
    #               summary: etcd cluster has insufficient number of members.
    #             expr: |
    #               sum(up{job=~".*etcd.*"} == bool 1) without (instance) < ((count(up{job=~".*etcd.*"}) without (instance) + 1) / 2)
    #             for: 3m
    #             labels:
    #               severity: critical
    #         # ...
    # -- Create a PrometheusRule resource (also requires `metrics.enabled` to be enabled)
    enabled: false
    # -- Additional labels that will be added to the PrometheusRule resource
    labels: {}
    # -- Namespace for the PrometheusRule resource (defaults to the release namespace)
    namespace: ""

networkPolicy:
  # -- Create a NetworkPolicy resource
  enabled: false
  # -- Allow all external connections from and to the pods
  allowExternalConnections: true
  egress:
    # -- Create an egress network policy (requires also `networkPolicy.enabled`)
    enabled: true
    # -- Allow all external egress connections from the pods (requires also `networkPolicy.allowExternalConnections`)
    allowExternalConnections: true
    # -- Custom additional egress rules to enable in the NetworkPolicy resource
    extraRules: []
    # -- List of namespace labels for which to allow egress connections, when external connections are disallowed
    namespaceLabels: {}
    # -- List of pod labels for which to allow egress connections, when external connections are disallowed
    podLabels: {}
    # Network policy port overrides for egress connections
    ports:
      # -- (int32) Network policy port override for etcd client connections for egress connections
      client: ""
      # -- (int32) Network policy port override for etcd peer connections for egress connections
      peer: ""
      # -- (int32) Network policy port override for custom ports specified in `containerPorts.*` for egress connections
      "*":
      # Note: This field is only added for documentation purposes
  ingress:
    # -- Create an ingress network policy (requires also `networkPolicy.enabled`)
    enabled: true
    # -- Allow all external ingress connections to the pods (requires also `networkPolicy.allowExternalConnections`)
    allowExternalConnections: true
    # -- List of namespace labels for which to allow ingress connections, when external connections are disallowed
    namespaceLabels: {}
    # -- List of pod labels for which to allow ingress connections, when external connections are disallowed
    podLabels: {}
    # -- Custom additional ingress rules to enable in the NetworkPolicy resource
    extraRules: []
    # Network policy port overrides for ingress connections
    ports:
      # -- (int32) Network policy port override for etcd client connections for ingress connections
      client: ""
      # -- (int32) Network policy port override for etcd peer connections for ingress connections
      peer: ""
      # -- (int32) Network policy port override for custom ports specified in `containerPorts.*` for ingress connections
      "*":
      # Note: This field is only added for documentation purposes

podDisruptionBudget:
  # -- Create a pod disruption budget
  enabled: false
  # -- Number of pods from that set that must still be available after the eviction, this option is mutually exclusive with maxUnavailable
  minAvailable: ""
  # -- Number of pods from that can be unavailable after the eviction, this option is mutually exclusive with minAvailable
  maxUnavailable: ""

service:
  # -- Create a service for etcd (apart from the headless service)
  enabled: true
  # -- Custom annotations to add to the service for etcd
  annotations: {}
  # -- Service type
  type: ClusterIP
  # Service nodePort values
  nodePorts:
    # -- (int32) Service nodePort override for etcd client connections
    client: ""
    # -- (int32) Service nodePort override for etcd peer connections
    peer: ""
    # -- (int32) Service nodePort override for custom ports specified in `containerPorts.*`
    "*":
    # Note: This field is only added for documentation purposes
  # Service port values
  ports:
    # -- (int32) Service port override for etcd client connections
    client: ""
    # -- (int32) Service port override for etcd peer connections
    peer: ""
    # -- (int32) Service port override for custom ports specified in `containerPorts.*`
    "*":
    # Note: This field is only added for documentation purposes
  # -- Custom attributes for the service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec))
  "*":
  # Note: This field is only added for documentation purposes

headlessService:
  # -- Custom annotations to add to the headless service for etcd
  annotations: {}
  # -- Headless service type
  type: ClusterIP
  # IP address of the service
  # When clusterIP is "None", no virtual IP is allocated and the endpoints are published as a set of endpoints rather than a virtual IP
  clusterIP: None
  # -- Disregard indications of ready/not-ready
  # The primary use case for setting this field is for a StatefulSet's Headless Service to propagate SRV DNS records for its Pods for the purpose of peer discovery
  publishNotReadyAddresses: true
  # Headless service port values
  ports:
    # -- (int32) Headless service port override for etcd client connections
    client: ""
    # -- (int32) Headless service port override for etcd peer connections
    peer: ""
    # -- (int32) Headless service port override for custom ports specified in `containerPorts.*`
    "*":
    # Note: This field is only added for documentation purposes
  # -- Custom attributes for the headless service (see [`ServiceSpec` API reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec))
  "*":
  # Note: This field is only added for documentation purposes

serviceAccount:
  # -- Create or use an existing service account
  enabled: false
  # -- Add custom annotations to the ServiceAccount
  annotations: {}
  # -- Add custom labels to the ServiceAccount
  labels: {}
  # -- Name of the ServiceAccount to use
  name: ""
  # -- Whether pods running as this service account should have an API token automatically mounted
  automountServiceAccountToken: true
  # -- List of references to secrets in the same namespace to use for pulling any images in pods that reference this ServiceAccount
  imagePullSecrets: []
  # -- List of secrets in the same namespace that pods running using this ServiceAccount are allowed to use
  secrets: []

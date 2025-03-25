# open-webui

![Version: 5.16.0](https://img.shields.io/badge/Version-5.16.0-informational?style=flat-square) ![AppVersion: 0.5.14](https://img.shields.io/badge/AppVersion-0.5.14-informational?style=flat-square)

Open WebUI is an extensible, feature-rich, and user-friendly self-hosted WebUI designed to operate entirely offline. It supports various LLM runners, including Ollama and OpenAI-compatible APIs.

**Homepage:** <https://apps.rancher.io/applications/open-webui>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| SUSE LLC |  | <https://www.suse.com> |

## Installing

To install the Helm chart with the release name *my-release*:

```shell
helm install my-release \
--set 'global.imagePullSecrets[0].name'=my-pull-secrets \
--set 'persistence.storageClass'=my-storage-class \
--set 'ingress.host'=my-host \
oci://dp.apps.rancher.io/charts/open-webui
```

## Requirements

| Repository | Name | Version | Note |
|------------|------|---------|------|
| oci://dp.apps.rancher.io/charts | ollama | =1.4.0 | By default, ollama is enabled   |
| oci://dp.apps.rancher.io/charts | apache-tika | =3.0.0 | By default, tika is disabled   |
| oci://dp.apps.rancher.io/charts | apache-redis | =1.0.3 | By default, websoket with redis manager is enabled   |
| ************ | pipelines | >=0.0.1 | Pipelines are disabled by default and SUSE does not support enabling pipelines for this release. Please refer to upstream pipelines chart https://github.com/open-webui/helm-charts/tree/main/charts/pipelines for deployment of pipelines outside of the scope of SUSE support |


## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| annotations | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` | Value of cluster domain |
| containerSecurityContext | object | `{}` | Configure container security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-containe> |
| copyAppData.resources | object | `{}` |  |
| extraEnvVars | list | `[{"name":"OPENAI_API_KEY","value":"0p3n-w3bu!"}]` | Env vars added to the Open WebUI deployment. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ |
| extraEnvVars[0] | object | `{"name":"OPENAI_API_KEY","value":"0p3n-w3bu!"}` | Default API key value for Pipelines. Should be updated in a production deployment, or be changed to the required API key if not using Pipelines |
| extraResources | list | `[]` | Extra resources to deploy with Open WebUI |
| global.imagePullSecrets | list | `[]` | Global override for container image registry pull secrets |
| global.imageRegistry | string | `""` | Global override for container image registry |
| global.tls.additionalTrustedCAs | bool | `false` |  |
| global.tls.issuerName | string | `"suse-private-ai"` |  |
| global.tls.letsEncrypt.email | string | `"none@example.com"` |  |
| global.tls.letsEncrypt.environment | string | `"staging"` |  |
| global.tls.letsEncrypt.ingress.class | string | `""` |  |
| global.tls.source | string | `"suse-private-ai"` |  |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy to use for the open-webui container |
| image.registry | string | `"dp.apps.rancher.io"` | Image registry to use for the open-webui container |
| image.repository | string | `"containers/open-webui"` | Image repository to use for the open-webui container |
| image.tag | string | `"0.5.14"` | Image tag to use for the open-webui container |
| imagePullSecrets | list | `[]` | Configure imagePullSecrets to use private registry ref: <https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry> |
| ingress.additionalHosts | list | `[]` |  |
| ingress.annotations | object | `{"nginx.ingress.kubernetes.io/ssl-redirect":"true"}` | Use appropriate annotations for your Ingress controller, e.g., for NGINX:   |
| ingress.class | string | `""` |  |
| ingress.enabled | bool | `true` |  |
| ingress.existingSecret | string | `""` |  |
| ingress.host | string | `""` |  |
| ingress.tls | bool | `true` |  |
| livenessProbe | object | `{}` | Probe for liveness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| managedCertificate.domains[0] | string | `"chat.example.com"` |  |
| managedCertificate.enabled | bool | `false` |  |
| managedCertificate.name | string | `"mydomain-chat-cert"` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. |
| ollama.enabled | bool | `true` | Automatically install Ollama Helm chart from dp.apps.rancher.io/charts/ollama |
| ollama.fullnameOverride | string | `"open-webui-ollama"` | If enabling embedded Ollama, update fullnameOverride to your desired Ollama name value, or else it will use the default ollama.name value from the Ollama chart |
| ollamaUrls | list | `[]` | A list of Ollama API endpoints. These can be added in lieu of automatically installing the Ollama Helm chart, or in addition to it. |
| ollamaUrlsFromExtraEnv | bool | `false` | Disables taking Ollama Urls from `ollamaUrls`  list |
| openaiBaseApiUrl | string | `"https://api.openai.com/v1"` | OpenAI base API URL to use. Defaults to the Pipelines service endpoint when Pipelines are enabled, and "https://api.openai.com/v1" if Pipelines are not enabled and this value is blank |
| openaiBaseApiUrls | list | `[]` | OpenAI base API URLs to use. Overwrites the value in openaiBaseApiUrl if set |
| persistence.accessModes | list | `["ReadWriteOnce"]` | If using multiple replicas, you must update accessModes to ReadWriteMany |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.existingClaim | string | `""` | Use existingClaim if you want to re-use an existing Open WebUI PVC instead of creating a new one |
| persistence.selector | object | `{}` |  |
| persistence.size | string | `"2Gi"` |  |
| persistence.storageClass | string | `""` |  |
| persistence.subPath | string | `""` | Subdirectory of Open WebUI PVC to mount. Useful if root directory is not empty. |
| pipelines.enabled | bool | `false` | Automatically install Pipelines chart to extend Open WebUI functionality using Pipelines: https://github.com/open-webui/pipelines |
| pipelines.extraEnvVars | list | `[]` | This section can be used to pass required environment variables to your pipelines (e.g. Langfuse hostname) |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` | Configure pod security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-containe> |
| readinessProbe | object | `{}` | Probe for readiness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| redis-cluster | object | `{"auth":{"enabled":false},"enabled":false,"fullnameOverride":"open-webui-redis","replica":{"replicaCount":3}}` | Deploys a Redis cluster with subchart 'redis' from bitnami |
| redis-cluster.auth | object | `{"enabled":false}` | Redis Authentication |
| redis-cluster.auth.enabled | bool | `false` | Enable Redis authentication (disabled by default). For your security, we strongly suggest that you switch to 'auth.enabled=true' |
| redis-cluster.enabled | bool | `false` | Enable Redis installation |
| redis-cluster.fullnameOverride | string | `"open-webui-redis"` | Redis cluster name (recommended to be 'open-webui-redis') - In this case, redis url will be 'redis://open-webui-redis-master:6379/0' or 'redis://[:<password>@]open-webui-redis-master:6379/0' |
| redis-cluster.replica | object | `{"replicaCount":3}` | Replica configuration for the Redis cluster |
| redis-cluster.replica.replicaCount | int | `3` | Number of Redis replica instances |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| service | object | `{"annotations":{},"containerPort":8080,"labels":{},"loadBalancerClass":"","nodePort":"","port":80,"type":"ClusterIP"}` | Service values to expose Open WebUI pods to cluster |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.enable | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| startupProbe | object | `{}` | Probe for startup of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| strategy | object | `{}` | Strategy for updating the workload manager: deployment or statefulset |
| tika.enabled | bool | `false` | Automatically install Apache Tika to extend Open WebUI |
| tolerations | list | `[]` | Tolerations for pod assignment |
| topologySpreadConstraints | list | `[]` | Topology Spread Constraints for pod assignment |
| volumeMounts | object | `{"container":[],"initContainer":[]}` | Configure container volume mounts ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/> |
| volumes | list | `[]` | Configure pod volumes ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/> |
| websocket.enabled | bool | `true` | Enables websocket support in Open WebUI with env `ENABLE_WEBSOCKET_SUPPORT` |
| websocket.manager | string | `"redis"` | Specifies the websocket manager to use with env `WEBSOCKET_MANAGER`: redis (default) |
| websocket.redis | object | `{"annotations":{},"args":[],"command":[],"enabled":true,"image":{"pullPolicy":"IfNotPresent","repository":"redis","tag":"7.4.2-alpine3.21"},"labels":{},"name":"open-webui-redis","pods":{"annotations":{}},"resources":{},"service":{"annotations":{},"containerPort":6379,"labels":{},"nodePort":"","port":6379,"type":"ClusterIP"}}` | Deploys a redis |
| websocket.redis.annotations | object | `{}` | Redis annotations |
| websocket.redis.args | list | `[]` | Redis arguments (overrides default) |
| websocket.redis.command | list | `[]` | Redis command (overrides default) |
| websocket.redis.enabled | bool | `true` | Enable redis installation |
| websocket.redis.image | object | `{"pullPolicy":"IfNotPresent","repository":"redis","tag":"7.4.2-alpine3.21"}` | Redis image |
| websocket.redis.labels | object | `{}` | Redis labels |
| websocket.redis.name | string | `"open-webui-redis"` | Redis name |
| websocket.redis.pods | object | `{"annotations":{}}` | Redis pod |
| websocket.redis.pods.annotations | object | `{}` | Redis pod annotations |
| websocket.redis.resources | object | `{}` | Redis resources |
| websocket.redis.service | object | `{"annotations":{},"containerPort":6379,"labels":{},"nodePort":"","port":6379,"type":"ClusterIP"}` | Redis service |
| websocket.redis.service.annotations | object | `{}` | Redis service annotations |
| websocket.redis.service.containerPort | int | `6379` | Redis container/target port |
| websocket.redis.service.labels | object | `{}` | Redis service labels |
| websocket.redis.service.nodePort | string | `""` | Redis service node port. Valid only when type is `NodePort` |
| websocket.redis.service.port | int | `6379` | Redis service port |
| websocket.redis.service.type | string | `"ClusterIP"` | Redis service type |
| websocket.url | string | `"redis://open-webui-redis:6379/0"` | Specifies the URL of the Redis instance for websocket communication. Template with `redis://[:<password>@]<hostname>:<port>/<db>` |

----------------------------------------------

TLS sources:
-
-There are three recommended options for the source of the certificate:
-
-- **Self-Signed (suse-private-ai) TLS certificate:** This is the default option. In this case, you will need to install cert-manager into the cluster. suse-private-ai utilizes cert-manager to issue and maintain its certificates. suse-private-ai will generate a CA certificate of its own, and sign a cert using that CA. cert-manager is then responsible for managing that certificate.
-
-- **Let's Encrypt (letsEncrypt):** The Let's Encrypt option also uses cert-manager. However, in this case, cert-manager is combined with a special Issuer for Let's Encrypt that performs all actions (including request and validation) necessary for getting a Let's Encrypt issued cert. This configuration uses HTTP validation (HTTP-01), so the load balancer must have a public DNS record and be accessible from the internet.
-
-- **Bring your own certificate:** This option allows you to bring your own signed certificate. suse-private-ai will use that certificate to secure HTTPS traffic. In this case, you must upload this certificate (and associated key) as PEM-encoded files with the name tls.crt and tls.key.
-
-| Configuration                  | Helm Chart Option           | Requires cert-manager                 |
-| ------------------------------ | ----------------------- | ------------------------------------- |
-| Self-Signed (suse-private-ai) Generated Certificates (Default) | `global.tls.source=suse-private-ai`  | yes |
-| Let’s Encrypt                  | `global.tls.source=letsEncrypt`  | yes |
-| Certificates from Files        | `global.tls.source=secret`        | no | 
-
-
-Integration with Milvus DB:
-
-```console
-helm install my-release \
---set 'global.imagePullSecrets[0].name'=my-pull-secrets \
---set 'persistence.storageClass'=my-storage-class \
---set 'ingress.host'=my-host \
---set 'extraEnvVars[0].name=VECTOR_DB' --set 'extraEnvVars[0].value=milvus' \
---set 'extraEnvVars[1].name=MILVUS_URI' --set-string 'extraEnvVars[1].value=http://<my-milvusuri>' \
-oci://dp.apps.rancher.io/charts/open-webui
-```

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs/).

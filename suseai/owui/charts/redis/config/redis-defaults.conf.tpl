bind 0.0.0.0 ::
{{- if not .Values.tls.enabled }}
port {{ printf "%d" (int .Values.containerPorts.redis) }}
{{- else }}
port 0
{{- end }}
dir {{ .Values.podTemplates.containers.redis.volumeMounts.data.mountPath }}
appendonly {{ ternary "yes" "no" .Values.appendOnlyFile }}

{{- if .Values.disableCommands }}
# Disable Redis commands for security purposes
{{- range .Values.disableCommands }}
rename-command {{ . }} ""
{{- end }}
{{- end }}

{{- if .Values.tls.enabled }}
# TLS configuration
tls-port {{ printf "%d" (int .Values.containerPorts.redis) }}
tls-cert-file {{ .Values.podTemplates.containers.redis.volumeMounts.certs.mountPath }}/{{ .Values.tls.certFilename }}
tls-key-file {{ .Values.podTemplates.containers.redis.volumeMounts.certs.mountPath }}/{{ .Values.tls.keyFilename }}
tls-ca-cert-file {{ .Values.podTemplates.containers.redis.volumeMounts.certs.mountPath }}/{{ .Values.tls.caCertFilename }}
tls-auth-clients {{ ternary "yes" "no" .Values.tls.authClients }}
tls-replication {{ ternary "yes" "no" .Values.tls.replication }}
{{- if .Values.tls.dhParamsFilename }}
tls-dh-params-file {{ .Values.podTemplates.containers.redis.volumeMounts.certs.mountPath }}/{{ .Values.tls.dhParamsFilename }}
{{- end }}
{{- end }}

{{- if eq .Values.architecture "cluster" }}
# Cluster configuration
cluster-enabled yes
cluster-config-file {{ .Values.cluster.configurationFile }}
{{- if .Values.useHostnames }}
cluster-preferred-endpoint-type hostname
{{- end }}
{{- if .Values.tls.enabled }}
tls-cluster {{ ternary "yes" "no" .Values.tls.cluster }}
{{- end }}
{{- end }}

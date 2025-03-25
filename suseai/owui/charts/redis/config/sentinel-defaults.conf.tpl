bind 0.0.0.0 ::
{{- if not .Values.tls.enabled }}
port {{ printf "%d" (int .Values.containerPorts.sentinel) }}
{{- else }}
port 0
{{- end }}

{{- if .Values.tls.enabled }}
# TLS configuration
tls-port {{ printf "%d" (int .Values.containerPorts.sentinel) }}
tls-cert-file {{ .Values.sentinel.podTemplates.containers.sentinel.volumeMounts.certs.mountPath }}/{{ .Values.tls.certFilename }}
tls-key-file {{ .Values.sentinel.podTemplates.containers.sentinel.volumeMounts.certs.mountPath }}/{{ .Values.tls.keyFilename }}
tls-ca-cert-file {{ .Values.sentinel.podTemplates.containers.sentinel.volumeMounts.certs.mountPath }}/{{ .Values.tls.caCertFilename }}
tls-auth-clients {{ ternary "yes" "no" .Values.tls.authClients }}
tls-replication {{ ternary "yes" "no" .Values.tls.replication }}
{{- if .Values.tls.dhParamsFilename }}
tls-dh-params-file {{ .Values.sentinel.podTemplates.containers.sentinel.volumeMounts.certs.mountPath }}/{{ .Values.tls.dhParamsFilename }}
{{- end }}
{{- end }}

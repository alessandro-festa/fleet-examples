{{/*
    Print true if RBAC authentication is enabled, false otherwise. Supports the following non-standard values:
    - auth.rbac.create
*/}}
{{- define "auth.rbac.enabled" }}
    {{- if kindIs "bool" .Values.auth.rbac.create }}
        {{- .Values.auth.rbac.create }}
    {{- else }}
        {{- .Values.auth.rbac.enabled }}
    {{- end }}
{{- end }}

{{/*
    Print the existing secret name for etcd RBAC configuration. Supports the following non-standard values:
    - auth.rbac.existingSecretPasswordKey
*/}}
{{- define "auth.rbac.rootPasswordKey" }}
    {{- coalesce .Values.auth.rbac.rootPasswordKey .Values.auth.rbac.existingSecretPasswordKey "root-password" }}
{{- end }}

{{/*
    etcd protocol to use for client connections.
*/}}
{{- define "clientProtocol" }}
    {{- .Values.transportSecurity.client.enabled | ternary "https" "http" }}
{{- end }}

{{/*
    etcd protocol to use for peer connections.
*/}}
{{- define "peerProtocol" }}
    {{- .Values.transportSecurity.peer.enabled | ternary "https" "http" }}
{{- end }}

{{/*
    etcd initial cluster nodes.
*/}}
{{- define "initialCluster" }}
    {{- $initialCluster := list }}
    {{- $fullName := include "fullName" . }}
    {{- $peerProtocol := include "peerProtocol" . }}
    {{- $serviceName := coalesce .Values.statefulset.serviceName (include "fullName" (dict "suffix" "headless" "context" .)) }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomain }}
    {{- $peerPort := int .Values.containerPorts.peer }}
    {{- range $node := (until (int .Values.statefulset.replicas)) }}
        {{- $initialCluster = append $initialCluster (printf "%s-%d=%s://%s-%d.%s.%s.svc.%s:%d" $fullName $node $peerProtocol $fullName $node $serviceName $releaseNamespace $clusterDomain $peerPort) }}
    {{- end }}
    {{- join "," $initialCluster }}
{{- end }}

{{/*
    etcd endpoints.
*/}}
{{- define "endpoints" }}
    {{- $endpoints := list }}
    {{- $fullName := include "fullName" . }}
    {{- $clientProtocol := include "clientProtocol" . }}
    {{- $serviceName := coalesce .Values.statefulset.serviceName (include "fullName" (dict "suffix" "headless" "context" .)) }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := .Values.clusterDomain }}
    {{- $clientPort := int .Values.containerPorts.client }}
    {{- range $node := (until (int .Values.statefulset.replicas)) }}
        {{- $endpoints = append $endpoints (printf "%s://%s-%d.%s.%s.svc.%s:%d" $clientProtocol $fullName $node $serviceName $releaseNamespace $clusterDomain $clientPort) }}
    {{- end }}
    {{- join "," $endpoints }}
{{- end }}

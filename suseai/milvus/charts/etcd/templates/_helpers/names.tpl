{{/*
    Define chart identifier to be used by the `helm.sh/chart` label.
*/}}
{{- define "chart" }}
    {{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Expand the name of the chart.
*/}}
{{- define "name" }}
    {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Create a default fully qualified app name that is valid for all Kubernetes name fields.
    If the release name contains the chart name, it will be used as a full name.
*/}}
{{- define "fullName" }}
    {{- $context := default . .context }}
    {{- $suffix := default "" .suffix }}
    {{- $fullName := coalesce $context.Values.fullNameOverride $context.Values.fullnameOverride }}
    {{- if not $fullName }}
        {{- $name := default $context.Chart.Name $context.Values.nameOverride }}
        {{- if contains $name $context.Release.Name }}
            {{- $fullName = $context.Release.Name }}
        {{- else }}
            {{- $fullName = printf "%s-%s" $context.Release.Name $name }}
        {{- end}}
    {{- end }}
    {{- printf "%s-%s" $fullName $suffix | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
    Name of a container image. It needs to follow RFC 1123, which requires lowercase characters.
*/}}
{{- define "containerName" -}}
    {{- lower . }}
{{- end -}}

{{/*
    Name of the service account to use.
*/}}
{{- define "serviceAccountName" -}}
    {{- if .Values.serviceAccount.create -}}
        {{- default (include "fullName" .) .Values.serviceAccount.name }}
    {{- else -}}
        {{- default "default" .Values.serviceAccount.name }}
    {{- end -}}
{{- end -}}

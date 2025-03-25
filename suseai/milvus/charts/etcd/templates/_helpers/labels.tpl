{{/*
    Renders Kubernetes labels for objects, given the list of standard labels as well as a set of common labels.
*/}}
{{- define "labels" }}
    {{- $context := default . .context }}
    {{- $standardLabels := dict
        "app.kubernetes.io/name" (include "name" $context)
        "app.kubernetes.io/instance" $context.Release.Name
        "app.kubernetes.io/managed-by" $context.Release.Service
        "helm.sh/chart" (include "chart" $context)
    }}
    {{- $component := .component }}
    {{- if eq $component "main" }}
        {{- $component = include "name" $context }}
    {{- end }}
    {{- if $component }}
        {{- $standardLabels = merge (dict "app.kubernetes.io/component" $component) $standardLabels }}
    {{- end }}
    {{- tpl (merge (default (dict) .additionalLabels) $context.Values.commonLabels $standardLabels | toYaml) $context }}
{{- end }}

{{/*
    Labels to use on immutable `matchLabels` and `selector` fields.
*/}}
{{- define "matchLabels" }}
    {{- $context := default . .context }}
    {{- $standardLabels := dict
        "app.kubernetes.io/name" (include "name" $context)
        "app.kubernetes.io/instance" $context.Release.Name
    }}
    {{- $component := .component }}
    {{- if eq $component "main" }}
        {{- $component = include "name" $context }}
    {{- end }}
    {{- if $component }}
        {{- $standardLabels = merge (dict "app.kubernetes.io/component" $component) $standardLabels }}
    {{- end }}
    {{- tpl (merge (default (dict) .additionalLabels) $context.Values.commonLabels $standardLabels | toYaml) $context }}
{{- end }}

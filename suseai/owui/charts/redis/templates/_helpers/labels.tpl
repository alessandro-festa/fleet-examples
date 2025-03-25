{{/*
    Renders Kubernetes labels for objects, given the list of standard labels as well as a set of common labels.
*/}}
{{- define "application-collection.labels.list" }}
    {{- $context := default . .context }}
    {{- $standardLabels := dict
        "app.kubernetes.io/name" (include "application-collection.name" $context)
        "app.kubernetes.io/instance" $context.Release.Name
        "app.kubernetes.io/managed-by" $context.Release.Service
        "helm.sh/chart" (include "application-collection.chart" $context)
    }}
    {{- $component := .component }}
    {{- if eq $component "main" }}
        {{- $component = include "application-collection.name" $context }}
    {{- end }}
    {{- if $component }}
        {{- $standardLabels = merge (dict "app.kubernetes.io/component" $component) $standardLabels }}
    {{- end }}
    {{- tpl (merge (default (dict) .additionalLabels) $context.Values.commonLabels $standardLabels | toYaml) $context }}
{{- end }}

{{/*
    Labels to use on immutable `matchLabels` and `selector` fields.
*/}}
{{- define "application-collection.labels.match" }}
    {{- $context := default . .context }}
    {{- $standardLabels := dict
        "app.kubernetes.io/name" (include "application-collection.name" $context)
        "app.kubernetes.io/instance" $context.Release.Name
    }}
    {{- $component := .component }}
    {{- if eq $component "main" }}
        {{- $component = include "application-collection.name" $context }}
    {{- end }}
    {{- if $component }}
        {{- $standardLabels = merge (dict "app.kubernetes.io/component" $component) $standardLabels }}
    {{- end }}
    {{- tpl (merge (default (dict) .additionalLabels) $context.Values.commonLabels $standardLabels | toYaml) $context }}
{{- end }}

{{/*
    Render chart annotations with the given additional annotations (if defined), and the common annotations.
*/}}
{{- define "application-collection.annotations.list" }}
    {{- $context := default . .context }}
    {{- tpl (merge (default (dict) .additionalAnnotations) $context.Values.commonAnnotations | toYaml) $context }}
{{- end }}

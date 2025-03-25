{{/*
    Render a set of Helm values into YAML, only if they have a non-empty value. Boolean, integer and float values will always be rendered.
*/}}
{{- define "renderValues" }}
    {{- $values := default (dict) .values }}
    {{- $keys := default (keys $values) .keys }}
    {{- $omitKeys := default (dict) .omitKeys }}
    {{- $result := dict }}
    {{- range $key := $keys }}
        {{- if or (not $omitKeys) (not (has $key $omitKeys)) }}
            {{- $value := get $values $key }}
            {{- if or $value (kindIs "bool" $value) (kindIs "int" $value) (kindIs "int64" $value) (kindIs "float64" $value) }}
                {{- $_ := set $result $key $value }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- if $result }}
        {{- $result | toYaml | nindent 0 }}
    {{- end }}
{{- end }}

{{/*
    Render the 'annotations' field into YAML, but only when there is at least one or more defined annotations.
*/}}
{{- define "renderAnnotations" }}
    {{- $annotations := include "annotations" . | fromYaml }}
    {{- include "renderValues" (dict "values" (dict "annotations" $annotations)) }}
{{- end }}

{{/*
    Render the 'labels' field into YAML, but only when there is at least one or more defined labels.
*/}}
{{- define "renderLabels" }}
    {{- $labels := include "labels" . | fromYaml }}
    {{- include "renderValues" (dict "values" (dict "labels" $labels)) }}
{{- end }}

{{/*
    Render 'env' fields from an input dictionary, priorizing those environment variables with a 'valueFrom' field.
*/}}
{{- define "renderContainerEnvValues" }}
    {{- $context := .context }}
    {{- $envValues := .envValues }}
    {{- $result := list }}
    {{- $priorizedEnvVars := list }}
    {{- range $envName, $envValue := $envValues }}
        {{- if and (not (kindIs "string" $envValue)) (eq (include "templateToBoolean" (dict "template" $envValue.enabled "context" $context)) "true") $envValue.valueFrom }}
            {{- $result = append $result (set (omit $envValue "enabled") "name" $envName) }}
            {{- $priorizedEnvVars = append $priorizedEnvVars $envName }}
        {{- end }}
    {{- end }}
    {{- range $envName, $envValue := $envValues }}
        {{- if not (has $envName $priorizedEnvVars) }}
            {{- if kindIs "string" $envValue }}
                {{- $result = append $result (dict "name" $envName "value" $envValue) }}
            {{- else if eq (include "templateToBoolean" (dict "template" $envValue.enabled "context" $context)) "true" }}
                {{- $result = append $result (set (omit $envValue "enabled") "name" $envName) }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- tpl (include "renderValues" (dict "omitKeys" (list "enabled") "values" (dict "env" $result))) $context }}
{{- end }}

{{/*
    Render a template with a true/false string value, and convert to a boolean
*/}}
{{- define "templateToBoolean" }}
    {{- $context := .context }}
    {{- $template := .template }}
    {{- if kindIs "bool" $template }}
        {{- $template }}
    {{- else }}
        {{- tpl $template $context }}
    {{- end }}
{{- end }}

{{/*
    Render statefulSets serviceName
*/}}
{{- define "renderServiceName" }}
    {{- $context := default . .context }}
    {{- $nodeType := .nodeType }}
    {{- $nodeValues := index $context.Values $nodeType }}
    {{- $customServiceName := $nodeValues.statefulset.serviceName }}
    {{- printf "%s" (coalesce $customServiceName (include "fullName" (dict "suffix" (printf "%s-%s" $nodeType "headless") "context" $context))) }}
{{- end }}

{{/*
    Render 'volumeMounts' fields from an input dictionary.
*/}}
{{- define "renderVolumeMounts" }}
    {{- $context := default . .context }}
    {{- $volumeMounts := list }}
    {{- $containerVolumeMounts := .containerVolumeMounts }}
    {{- if $containerVolumeMounts }}
    {{- range $volumeMountName, $volumeMount := $containerVolumeMounts }}
    {{- if and $volumeMount (eq (include "templateToBoolean" (dict "template" $volumeMount.enabled "context" $context)) "true") }}
        {{- $volumeCount := default "1" (tpl (toString $volumeMount.volumeCount) $context) }}
        {{- if gt (int $volumeCount) 1}}
            {{- range $i := until (int $volumeCount) }}
                {{- $newVolumeMount := deepCopy $volumeMount }}
                {{- $newVolumeMountName := printf "%s-%d" $volumeMountName $i }}
                {{- $newVolumeMountPath := printf "%s-%d" $volumeMount.mountPath $i }}
                {{- $newVolumeMount = set $newVolumeMount "mountPath" $newVolumeMountPath }}
                {{- $volumeMounts = append $volumeMounts (set (omit $newVolumeMount "enabled" "name" "volumeCount") "name" $newVolumeMountName) }}
            {{- end }}
        {{- else }}
            {{- $volumeMounts = append $volumeMounts (set (omit $volumeMount "enabled" "name" "volumeCount") "name" $volumeMountName) }}
        {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- tpl (include "renderValues" (dict "values" (dict "volumeMounts" $volumeMounts))) $context }}
{{- end }}

{{/*
    Render 'volumes' fields from an input dictionary.
*/}}
{{- define "renderVolumes" }}
    {{- $context := default . .context }}
    {{- $volumes := list }}
    {{- $containerVolumes := .containerVolumes }}
    {{- if $containerVolumes }}
    {{- range $volumeName, $volume := $containerVolumes }}
    {{- if and $volume (eq (include "templateToBoolean" (dict "template" $volume.enabled "context" $context)) "true") }}
        {{- $volumeCount := default "1" (tpl (toString $volume.volumeCount) $context) }}
        {{- if gt (int $volumeCount) 1}}
            {{- range $i := until (int $volumeCount) }}
                {{- $newVolume := deepCopy $volume }}
                {{- $newVolumeName := printf "%s-%d" $volumeName $i }}
                {{- $volumes = append $volumes (set (omit $newVolume "enabled" "name" "volumeCount") "name" $newVolumeName) }}
            {{- end }}
        {{- else }}
            {{- $volumes = append $volumes (set (omit $volume "enabled" "name" "volumeCount") "name" $volumeName) }}
        {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- tpl (include "renderValues" (dict "values" (dict "volumes" $volumes))) $context }}
{{- end }}

{{/*
    Render 'volumeClaimTemplates' fields from an input dictionary.
*/}}
{{- define "renderVolumeClaimTemplates" }}
    {{- $context := default . .context }}
    {{- $volumeClaimTemplates := .volumeClaimTemplates }}
    {{- $persistence := default $context.Values.persistence .persistence }}
    {{- $vcts := list }}

    {{- if $volumeClaimTemplates }}
    {{- range $vctName, $vct := $volumeClaimTemplates }}
    {{- if and $vct (eq (include "templateToBoolean" (dict "template" $vct.enabled "context" $context)) "true") }}
        {{- $metadata := dict }}
        {{- if $context.Values.persistence.labels }}
            {{- $_ := set $metadata "labels" $persistence.labels }}
        {{- end }}
        {{- if $context.Values.persistence.annotations }}
            {{- $_ := set $metadata "annotations" $persistence.annotations }}
        {{- end }}
        {{- $_ := set $persistence "storageClassName" (coalesce $persistence.storageClassName $context.Values.global.storageClassName) }}

        {{- $volumeCount := default "1" (tpl (toString $vct.volumeCount) $context) }}
        {{- if gt (int $volumeCount) 1}}
            {{- range $i := until (int $volumeCount) }}
                {{- $newVct := deepCopy $vct }}
                {{- $newMetadata := deepCopy $metadata }}
                {{- $_ := set $newMetadata "name" (printf "%s-%d" $vctName $i) }}
                {{- $final := dict "metadata" $newMetadata "spec" (include "renderValues" (dict "omitKeys" (list "enabled" "annotations" "labels") "values" $persistence) | fromYaml) }}
                {{- $vcts = append $vcts $final }}
            {{- end }}
        {{- else }}
            {{- $_ := set $metadata "name" $vctName }}
            {{- $final := dict "metadata" $metadata "spec" (include "renderValues" (dict "omitKeys" (list "enabled" "annotations" "labels") "values" $persistence) | fromYaml) }}
            {{- $vcts = append $vcts $final }}
        {{- end }}
    {{- end }}
    {{- end }}
    {{- end }}
    {{- tpl (include "renderValues" (dict "values" (dict "volumeClaimTemplates" $vcts))) $context }}
{{- end }}

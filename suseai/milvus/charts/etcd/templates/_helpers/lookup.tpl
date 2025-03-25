{{/*
    Retrieve a config map value, or a default value if it does not exist
*/}}
{{- define "lookupConfigMap" }}
    {{- $context := default . .context }}
    {{- $configMap := default (include "fullName" $context) .configMap }}
    {{- $value := .default }}
    {{- if .key }}
        {{- $existingConfigMap := lookup "v1" "ConfigMap" $context.Release.Namespace $configMap }}
        {{- if and $existingConfigMap $existingConfigMap.data }}
            {{- if index $existingConfigMap.data .key }}
                {{- $value = index $existingConfigMap.data .key }}
            {{- else }}
                {{- printf "ERROR: The %s configmap does not contain the %s key" $configMap .key | fail }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- $value }}
{{- end }}

{{/*
    Retrieve a secret value, or a default value if it does not exist
*/}}
{{- define "lookupSecret" }}
    {{- $context := default . .context }}
    {{- $secret := default (include "fullName" $context) .secret }}
    {{- $value := .default | b64enc }}
    {{- if .key }}
        {{- $existingSecret := lookup "v1" "Secret" $context.Release.Namespace $secret }}
        {{- if and $existingSecret $existingSecret.data }}
            {{- if index $existingSecret.data .key }}
                {{- $value = index $existingSecret.data .key }}
            {{- else }}
                {{- printf "ERROR: The %s secret does not contain the %s key" $secret .key | fail }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- $value }}
{{- end }}

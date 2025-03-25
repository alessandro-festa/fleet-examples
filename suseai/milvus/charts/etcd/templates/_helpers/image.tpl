{{/*
    Print container image identifier, with a digest, a tag, or only with the provided image repository.
*/}}
{{- define "image" }}
    {{- if .registry }}
        {{- if .digest }}
            {{- printf "%s/%s@%s" .registry .repository .digest }}
        {{- else if .tag }}
            {{- printf "%s/%s:%s" .registry .repository .tag }}
        {{- else }}
            {{- .repository }}
        {{- end }}
    {{- else }}
        {{- if .digest }}
            {{- printf "%s@%s" .repository .digest }}
        {{- else if .tag }}
            {{- printf "%s:%s" .repository .tag }}
        {{- else }}
            {{- .repository }}
        {{- end }}
    {{- end }}
{{- end }}

{{/*
    Print the image pull secrets in the expected format (an array of objects with one possible field, "name").
*/}}
{{- define "imagePullSecrets" }}
    {{- $imagePullSecrets := list }}
    {{- range . }}
        {{- if kindIs "string" . }}
            {{- $imagePullSecrets = append $imagePullSecrets (dict "name" .) }}
        {{- else }}
            {{- $imagePullSecrets = append $imagePullSecrets . }}
        {{- end }}
    {{- end }}
    {{- toYaml $imagePullSecrets }}
{{- end }}

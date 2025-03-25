{{/*
    Print true if authentication is enabled, false otherwise.
*/}}
{{- define "auth.enabled" }}
    {{- .Values.auth.enabled }}
{{- end }}

{{/*
    Print the existing secret name for authentication configuration. Supports the following non-standard values:
    - auth.existingSecretPasswordKey
*/}}
{{- define "auth.passwordKey" }}
    {{- coalesce .Values.auth.passwordKey .Values.auth.existingSecretPasswordKey "password" }}
{{- end }}

{{- define "configuration" }}
    {{- $context := default . .context }}
    {{- $configuration := .values }}
    {{- $configurationEntries := list }}
    {{- if kindIs "string" $configuration }}
        {{- $configurationEntries = append $configurationEntries (tpl $configuration $) }}
    {{- else if kindIs "array" $configuration }}
        {{- $configurationEntries = concat $configurationEntries (tpl $configuration $) }}
    {{- else }}
        {{- range $configKey, $configValue := $configuration }}
            {{- if not (kindIs "string" $configValue) }}
                {{- if eq (include "templateToBoolean" (dict "template" $configValue.enabled "context" $context)) "true" }}
                    {{- $configurationEntries = append $configurationEntries (printf "%s=%s" (tpl $configKey $context) (tpl $configValue.value $context)) }}
                {{- end }}
            {{- else }}
                {{- $configurationEntries = append $configurationEntries (printf "%s=%s" (tpl $configKey $context) (tpl $configValue $context)) }}
            {{- end }}
        {{- end }}
    {{- end }}
    {{- if $configurationEntries }}
        {{- join "\n" $configurationEntries | nindent 0 }}
    {{- end }}
{{- end }}

{{/*
    Apache Kafka Cluster nodes.
*/}}
{{- define "quorumVoters" }}
    {{- $context := default . .context }}
    {{- $quorumVoters := list }}
    {{- $fullName := include "fullName" (dict "suffix" "controller" "context" $context) }}
    {{- $serviceName := coalesce $context.Values.controller.statefulset.serviceName (include "fullName" (dict "suffix" (printf "%s-%s" "controller" "headless") "context" $context)) }}
    {{- $releaseNamespace := .Release.Namespace }}
    {{- $clusterDomain := $context.Values.clusterDomain }}
    {{- $port := int (coalesce $context.Values.controller.headlessService.ports.controller $context.Values.containerPorts.controller) }}
    {{- range $node := (until (int (include "nodeCount" (dict "nodeType" "controller" "context" $context)))) }}
        {{- $quorumVoters = append $quorumVoters (printf "%d@%s-%d.%s.%s.svc.%s:%d" $node $fullName $node $serviceName $releaseNamespace $clusterDomain $port) }}
    {{- end }}
    {{- join "," $quorumVoters }}
{{- end }}

{{/*
    Apache Kafka Listeners
*/}}
{{- define "listeners" }}
    {{- $listenerURIs := list }}
    {{- $context := default . .context }}
    {{- $listeners := .listeners }}
    {{- $nodeType := .nodeType }}
    {{- $hostname := default "hostname-placeholder" .hostname }}
    {{- $serviceName := include "renderServiceName" (dict "nodeType" $nodeType "context" $context) }}

    {{- range $listener := $listeners }}
        {{- $nodeValues := index $context.Values $nodeType }}
        {{- $headlessServicePorts := $nodeValues.headlessService.ports }}

        {{- $port := int (coalesce (index $headlessServicePorts $listener) (index $context.Values.containerPorts $listener)) }}
        {{- $listenerMap := index $context.Values.cluster.listeners $listener }}
        {{- $podFQDN := include "podFQDN" (dict "hostname" $hostname "serviceName" $serviceName "context" $context) }}
        {{- $listenerURIs = append $listenerURIs (printf "%s://%s:%d" (upper $listenerMap.name) $podFQDN $port) }}
    {{- end }}
    {{- join "," $listenerURIs }}
{{- end }}

{{/*
    Define Apache Kafka log dirs value
*/}}
{{- define "logDirs" }}
    {{- $context := default . .context }}
    {{- $mountPath := .mountPath }}
    {{- $disksPerBroker := $context.Values.cluster.disksPerBroker }}
    {{- if gt (int $disksPerBroker) 1}}
        {{- $logDirs := list }}
        {{- range $i := until (int $disksPerBroker) }}
            {{- $logDirs = append $logDirs (printf "%s-%d" $mountPath $i) }}
        {{- end }}
    {{- join "," $logDirs }}
    {{- else }}
        {{- printf "%s" $mountPath }}
    {{- end }}
{{- end }}

{{/*
    Check whether Apache Kafka standalone brokers are to be deployed
*/}}
{{- define "areStandaloneBrokersEnabled" }}
    {{- $context := default . .context }}
    {{- if and $context.Values.broker.enabled $context.Values.broker.statefulset.enabled $context.Values.broker.podTemplates.containers.broker.enabled }}
        {{- true }}
    {{- end }}
{{- end }}

{{/*
    Return the desired nodeCount
*/}}
{{- define "nodeCount" }}
    {{- $context := default . .context }}
    {{- $nodeType := .nodeType }}
    {{- $brokerCount := 0 }}
    {{- $controllerCount := coalesce $context.Values.controller.statefulset.replicas $context.Values.cluster.nodeCount.controller }}
    {{- if eq $nodeType "controller" }}
        {{- printf "%d" (int $controllerCount) }}
    {{- else if eq $nodeType "broker" }}
        {{- if eq (include "templateToBoolean" (dict "template" (include "areStandaloneBrokersEnabled" $context) "context" $context)) "true" }}
            {{- $brokerCount = coalesce $context.Values.broker.statefulset.replicas $context.Values.cluster.nodeCount.broker }}
        {{- end }}
        {{- printf "%d" (int $brokerCount) }}
    {{- end }}
{{- end }}


{{/*
    Apache Kafka Listener's security protocol map
*/}}
{{- define "protocolMap" }}
    {{- $context := default . .context }}
    {{- $protocolMap := list }}
    {{- range $listenerKey, $listenerConfig := $context.Values.cluster.listeners }}
        {{- if not (eq $listenerKey "*") }}
            {{- $protocolMap = append $protocolMap (printf "%s:%s" $listenerConfig.name $listenerConfig.protocol) }}
        {{- end }}
    {{- end }}
    {{- join "," $protocolMap }}
{{- end }}

{{/*
    Apache Kafka Listener's JAAS configuration key
*/}}
{{- define "jaasConfigKey" }}
    {{- $context := default . .context }}
    {{- $listener := .listener }}
    {{- printf "%s_%s_%s_%s" "KAFKA_LISTENER_NAME" (upper $listener.name) (upper $listener.saslMechanism) "SASL_JAAS_CONFIG" }}
{{- end }}

{{/*
    Apache Kafka Listener's JAAS configuration key
*/}}
{{- define "jaasConfigValue" }}
    {{- $context := default . .context }}
    {{- $listenerType := .listenerType }}
    {{- $listener := .listener }}
    {{- $hostname := .hostname }}
    {{- $nodeType := .nodeType }}
    {{- $loginModule := "" }}
    {{- $authData := "" }}

    {{- if eq $listener.saslMechanism "GSSAPI" }}
        {{- $mountPath := "" }}
        {{- $loginModule = "com.sun.security.auth.module.Krb5LoginModule required" }}
        {{- $serviceName := include "renderServiceName" (dict "nodeType" $nodeType "context" $context) }}
        {{- $principal := include "podFQDN" (dict "hostname" $hostname "serviceName" $serviceName "context" $context) }}
        {{- if eq $nodeType "controller" }}
            {{- $mountPath = $context.Values.controller.podTemplates.containers.controller.volumeMounts.sasl.mountPath }}
        {{- else if eq $nodeType "broker" }}
            {{- $mountPath = $context.Values.broker.podTemplates.containers.broker.volumeMounts.sasl.mountPath }}
        {{- end }}
        {{- $keyTab := printf "%s/%s.%s" $mountPath $hostname "keytab" }}
        {{- $authData = printf "useKeyTab=true storeKey=true keyTab=%s principal=%s" $keyTab $principal }}

    {{- else if eq $listener.saslMechanism "PLAIN" }}
        {{- $loginModule = "org.apache.kafka.common.security.plain.PlainLoginModule required" }}
        {{- $authData = include "plainUsers" (dict "listenerType" $listenerType "context" $context) }}

    {{- else if eq $listener.saslMechanism "OAUTHBEARER" }}
        {{- $loginModule = "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required" }}
        {{- if not (empty $context.Values.auth.sasl.oauthbearer.unsecuredLoginClaimSub) }}
            {{- $authData = printf "unsecuredLoginStringClaim_sub=%s" $context.Values.auth.sasl.oauthbearer.unsecuredLoginClaimSub }}
        {{- end }}
    {{- end }}

    {{- printf "%s %s;" $loginModule $authData }}
{{- end }}

{{/*
    Apache Kafka Listener's JAAS SASL/PLAIN users
*/}}
{{- define "plainUsers" }}
    {{- $context := default . .context }}
    {{- $listenerType := .listenerType }}
    {{- $interbrokerUsername := default "" $context.Values.auth.sasl.plain.interbrokerUsername }}
    {{- $interbrokerPassword := default "" $context.Values.auth.sasl.plain.interbrokerPassword }}
    {{- $users := list }}

    {{- if or (eq $listenerType "controller") (eq $listenerType "interbroker") }}
        {{- $users = append $users (printf "username=%s password=%s" $interbrokerUsername $interbrokerPassword) }}
        {{- $users = append $users (printf "user_%s=%s" $interbrokerUsername $interbrokerPassword) }}
    {{- end }}
    {{- if or (eq $listenerType "client") (eq $listenerType "interbroker") }}
        {{- range $username, $password := $context.Values.auth.sasl.plain.users }}
            {{- $users = append $users (printf "user_%s=%s" $username $password) }}
        {{- end }}
    {{- end }}
    {{- if eq $listenerType "controller_healthcheck" }}
        {{- $users = append $users (printf "username=%s password=%s" $interbrokerUsername $interbrokerPassword) }}
    {{- end }}
    {{- if eq $listenerType "broker_healthcheck" }}
        {{- range $username, $password := $context.Values.auth.sasl.plain.users }}
            {{- $users = append $users (printf "username=%s password=%s" $username $password) }}
            {{- break -}}
        {{- end }}
    {{- end }}
    {{- join " " $users }}
{{- end }}

{{/*
    Check whether Apache Kafka standalone brokers are to be deployed
*/}}
{{- define "fileToMultilineString" }}
    {{- $context := default . .context }}
    {{- $file := .file }}
    {{- $fileContent := $context.Files.Get $file }}
    {{- printf "%s" (replace "\n" "\\\n" $fileContent) }}
{{- end }}

{{/*
    Returns the nodeID for a given node
*/}}
{{- define "getNodeID" }}
    {{- $context := default . .context }}
    {{- $hostname := .hostname }}
    {{- $minBrokerID := default 0 .minBrokerID }}
    {{- $helmID := splitList "" $hostname | last }}
    {{- add $helmID $minBrokerID }}
{{- end }}

{{/*
    Return a pod's FQDN given its hostname and service name
*/}}
{{- define "podFQDN" }}
    {{- $context := default . .context }}
    {{- $hostname := .hostname }}
    {{- $serviceName := .serviceName }}
    {{- $releaseNamespace := $context.Release.Namespace }}
    {{- $clusterDomain := $context.Values.clusterDomain }}

    {{- printf "%s.%s.%s.svc.%s" $hostname $serviceName $releaseNamespace $clusterDomain }}
{{- end }}

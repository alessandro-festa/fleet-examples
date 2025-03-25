# Apache Kafka Helm Chart

> [Apache Kafka](https://kafka.apache.org/) is an open-source distributed event streaming platform used by thousands of companies for high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.

## Introduction

This Helm chart bootstraps an [Apache Kafka](https://kafka.apache.org/) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Quick Start

```console
helm install my-release ${CHART_REGISTRY}/charts/apache-kafka \
    --set global.imagePullSecrets={application-collection}
```

### Prerequisites

* Helm 3.8.0 or later.
* Kubernetes 1.24 or later.
* PV provisioner support in the underlying infrastructure.

## Install Chart

To install the Helm chart with the release name *my-release*:

```console
helm install my-release \
    --set 'global.imagePullSecrets[0].name'=my-pull-secrets \
    ${CHART_REGISTRY}/charts/apache-kafka \
```

This deploys the application to the Kubernetes cluster using the default configuration provided by the Helm chart.

> NOTE: You can follow [these steps](https://docs.apps.rancher.io/get-started/authentication/#kubernetes)
> to create and setup the image pull secrets, if you don't have them already.

## Uninstall Chart

To uninstall the Helm chart with the release name *my-release*:

```console
helm uninstall my-release
```

## Configuration

To view support configuration options and documentation, run:

```console
helm show values ${CHART_REGISTRY}/charts/apache-kafka
```

### Global Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
{{- range .Values }}
  {{- if hasPrefix "global" .Key }}
| {{ .Key }} | {{ .Type }} | {{ if .Default }}{{ .Default }}{{ else }}{{ .AutoDefault }}{{ end }} | {{ if .Description }}{{ .Description }}{{ else }}{{ .AutoDescription }}{{ end }} |
  {{- end }}
{{- end }}

### General Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
{{- range .Values }}
  {{- if not (or (hasPrefix "global" .Key) (hasPrefix "cluster" .Key) (hasPrefix "controller" .Key) (hasPrefix "broker" .Key)) }}
| {{ .Key }} | {{ .Type }} | {{ if .Default }}{{ .Default }}{{ else }}{{ .AutoDefault }}{{ end }} | {{ if .Description }}{{ .Description }}{{ else }}{{ .AutoDescription }}{{ end }} |
  {{- end }}
{{- end }}

### Kafka cluster Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
{{- range .Values }}
  {{- if hasPrefix "cluster" .Key }}
| {{ .Key }} | {{ .Type }} | {{ if .Default }}{{ .Default }}{{ else }}{{ .AutoDefault }}{{ end }} | {{ if .Description }}{{ .Description }}{{ else }}{{ .AutoDescription }}{{ end }} |
  {{- end }}
{{- end }}

### Controller node Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
{{- range .Values }}
  {{- if hasPrefix "controller" .Key }}
| {{ .Key }} | {{ .Type }} | {{ if .Default }}{{ .Default }}{{ else }}{{ .AutoDefault }}{{ end }} | {{ if .Description }}{{ .Description }}{{ else }}{{ .AutoDescription }}{{ end }} |
  {{- end }}
{{- end }}

### Broker node Configs

| Key | Type | Default | Description |
|-----|------|---------|-------------|
{{- range .Values }}
  {{- if hasPrefix "broker" .Key }}
| {{ .Key }} | {{ .Type }} | {{ if .Default }}{{ .Default }}{{ else }}{{ .AutoDefault }}{{ end }} | {{ if .Description }}{{ .Description }}{{ else }}{{ .AutoDescription }}{{ end }} |
  {{- end }}
{{- end }}

### Override Values

To override a parameter, add *--set* flags to the *helm install* command. For example:

```console
helm install my-release --set images.controller.tag=${APP_VERSION} ${CHART_REGISTRY}/charts/apache-kafka
```

Alternatively, you can override the parameter values using a custom YAML file with the *-f* flag. For example:

```console
helm install my-release -f custom-values.yaml ${CHART_REGISTRY}/charts/apache-kafka
```

Read more about [Values files](https://helm.sh/docs/chart_template_guide/values_files/) in the [Helm documentation](https://helm.sh/docs/).

## Missing Features

The following features are acknowledged missing from this Helm chart, and are expected to be added in a future revision:

* Metrics support via JMX Exporter
* Zookeeper mode

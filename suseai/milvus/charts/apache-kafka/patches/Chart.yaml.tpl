#!BuildTag: apache-kafka:${VERSION}-%RELEASE%
#!BuildTag: apache-kafka:${VERSION}
annotations:
  helm.sh/images: |
    - image: ${CONTAINER_REGISTRY}/containers/apache-kafka:${APP_VERSION}
      name: apache-kafka
    - image: ${CONTAINER_REGISTRY}/containers/bci-busybox:15.6
      name: bci-busybox
apiVersion: v2
appVersion: ${APP_VERSION}
description: Apache Kafka is a high-performance data structure server that primarily serves key/value workloads. It supports a wide range of native structures and an extensible plugin system for adding new data structures and access patterns.
home: https://apps.rancher.io/applications/apache-kafka
maintainers:
  - name: SUSE LLC
    url: https://www.suse.com/
name: apache-kafka
version: ${VERSION}

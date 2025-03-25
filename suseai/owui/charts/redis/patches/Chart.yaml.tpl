#!BuildTag: redis:${VERSION}-%RELEASE%
#!BuildTag: redis:${VERSION}
annotations:
  helm.sh/images: |
    - image: ${CONTAINER_REGISTRY}/containers/redis:${APP_VERSION}
      name: redis
    - image: ${CONTAINER_REGISTRY}/containers/redis-exporter:1
      name: redis-exporter
    - image: ${CONTAINER_REGISTRY}/containers/bci-busybox:15.6
      name: bci-busybox
apiVersion: v2
appVersion: ${APP_VERSION}
description: Redis is an open-source, in-memory data store used by millions of developers as a cache, vector database, document database, streaming engine, and message broker.
home: https://apps.rancher.io/applications/redis
icon: https://apps.rancher.io/logos/redis.png
maintainers:
  - name: SUSE LLC
    url: https://www.suse.com/
name: redis
version: ${VERSION}

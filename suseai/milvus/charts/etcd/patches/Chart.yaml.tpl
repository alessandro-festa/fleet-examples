#!BuildTag: etcd:${VERSION}-%RELEASE%
#!BuildTag: etcd:${VERSION}
annotations:
  helm.sh/images: |
    - image: ${CONTAINER_REGISTRY}/containers/etcd:${APP_VERSION}
      name: etcd
    - image: ${CONTAINER_REGISTRY}/containers/bci-busybox:15.6
      name: bci-busybox
apiVersion: v2
appVersion: ${APP_VERSION}
description: etcd is a distributed, reliable key-value store for the most critical data of a distributed system.
home: https://apps.rancher.io/applications/etcd
icon: https://etcd.io/favicon.png
maintainers:
  - name: SUSE LLC
    url: https://www.suse.com/
name: etcd
version: ${VERSION}

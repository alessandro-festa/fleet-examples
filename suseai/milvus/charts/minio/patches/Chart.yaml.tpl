#!BuildTag: minio:${VERSION}-%RELEASE%
#!BuildTag: minio:${VERSION}
annotations:
  helm.sh/images: |
    - image: ${CONTAINER_REGISTRY}/containers/minio:${APP_VERSION}
      name: minio
    - image: ${CONTAINER_REGISTRY}/containers/mc:0
      name: mc
apiVersion: v2
appVersion: ${APP_VERSION}
description: MinIO is a High Performance Object Storage, API compatible with Amazon S3 cloud storage service. Use MinIO to build high performance infrastructure for machine learning, analytics and application data workloads.
home: https://apps.rancher.io/applications/minio
maintainers:
  - name: SUSE LLC
    url: https://www.suse.com/
name: minio
version: ${VERSION}

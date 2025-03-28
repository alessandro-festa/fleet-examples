# /bin/bash

helm upgrade --install aiva . \
  --set global.ngcImagePullSecretName=ngc-docker-reg-secret \
  --set ranking-ms.applicationSpecs.ranking-deployment.containers.ranking-container.env[0].name=NGC_API_KEY \
  --set ranking-ms.applicationSpecs.ranking-deployment.containers.ranking-container.env[0].value=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 \
  --set nemollm-inference.applicationSpecs.nemollm-infer-deployment.containers.nemollm-infer-container.env[0].name=NGC_API_KEY \
  --set nemollm-inference.applicationSpecs.nemollm-infer-deployment.containers.nemollm-infer-container.env[0].value=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 \
  --set nemollm-embedding.applicationSpecs.embedding-deployment.containers.embedding-container.env[0].name=NGC_API_KEY \
  --set nemollm-embedding.applicationSpecs.embedding-deployment.containers.embedding-container.env[0].value=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

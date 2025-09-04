
# GreenDoc - SUSEAI Demo Lab

*Author:* Alessandro Festa

*Rev. Number:* v1.0

SUSE AI Demo enviroment is a simple document that is intended to describe how to implement a local lab to demonstrate capabilites of SUSE AI 
If you are interested in understanding more what is SUSE AI please refer to [http://suse.com/products/ai](http://suse.com/products/ai)

The applications in this repo are pulled from the SUSE Application Collection [https://apps.rancher.io/](https://apps.rancher.io/) check the documentation at [https://docs.apps.rancher.io/](https://docs.apps.rancher.io/) to learn more about AppCo

This GreenDoc is structured in the following way:

* Cluster setup
* Rancher Fleet setup (for automation of the GreenDoc)
* GreenDoc Configuration
* GreenDoc deployment
* Simple final Demo


## Cluster Setup

For the purpose of this GreenDoc we'll use [K3s](https://k3s.io).

### Create namespaces used in the environment

```SHELL
kubectl create namespace cert-manager
```
```SHELL
kubectl create namespace suseai
```

### Create secrets for namespaces

```SHELL
kubectl create secret docker-registry application-collection \
--docker-server=dp.apps.rancher.io \
--docker-username=<your registered account on appco> \
--docker-password=<INSERT YOUR TOKEN FROM APPCO> \
-n cert-manager
```

```SHELL
kubectl create secret docker-registry application-collection \
--docker-server=dp.apps.rancher.io \
--docker-username=<your registered account on appco>\
--docker-password=<INSERT YOUR TOKEN FROM APPCO> \
-n suseai
```

## Use Rancher Application Collection for components

### Deploy cert-manager helm chart

```SHELL
helm upgrade --install cert-manager \
  oci://dp.apps.rancher.io/charts/cert-manager \
  --version 1.17.2 \
  -n cert-manager \
  --create-namespace \
  --set crds.enabled=true \
  --set "global.imagePullSecrets[0].name"="application-collection"
```

### Deploy Rancher Fleet

```SHELL
helm -n cattle-fleet-system install --create-namespace --wait fleet-crd \
    fleet/fleet-crd
```
```SHELL
helm -n cattle-fleet-system install --create-namespace --wait fleet \
    fleet/fleet
```
At this point we are ready to pickup the greendoc recipe

## Deploy a minimal SUSEAI Stack with Rancher Fleet

Let's create a minimal github configuration and save it as suseai.yaml

```YAML
apiVersion: fleet.cattle.io/v1alpha1
kind: GitRepo
metadata:
  name: suseai
  # This namespace is special and auto-wired to deploy to the local cluster
  namespace: fleet-local
spec:
  repo: https://github.com/alessandro-festa/demos
  helmSecretName: basic-auth-secret
  ociRegistry:
    authSecretName: application-collection
  branch: main
  paths:
  - suse-ai
```
and add a generic secret for basic authentication

```SHELL
kubectl create secret generic basic-auth-secret \--from-literal=username=<your registered account on appco> \
--from-literal=password=<INSERT YOUR TOKEN FROM APPCO> \
-n fleet-local
```
Now let's execute the config with kubectl

```SHELL
kubectl apply -f fleet-deployment.yaml
```
You should have minimal SUSE AI stack deployed

Let's check that! Simply open a browser and point to [http://localhost:31000](http://localhost:31000)

# A very simple demo

Now let's customize a bit our little environment. We want to create a very basic custom model that has a a custom system prompt

Let's go back to our Ollama yaml file and let's add this section below after

```SHELL
ollama: 
  # -- List of models to pull at container startup
  models:
    pull:
      - qwen2.5:0.5b-instruct
```

```SHELL
ollama: 
  # -- List of models to pull at container startup
  models:
    pull:
      - gemma3:1b-it-qat
    create:
      - name: suseai-k8s
        template: |
          FROM gemma3:1b-it-qat
          # sets the temperature to 1 [higher is more creative, lower is more coherent]
          PARAMETER temperature 1
          # sets the context window size to 4096, this controls how many tokens the LLM can use as context to generate the next token
          PARAMETER num_ctx 4096

          # sets a custom system message to specify the behavior of the chat assistant
          SYSTEM """ You are an advanced RBAC assistant for Rancher and Kubernetes environments. 
          Your role is to provide tailored recommendations for RBAC configurations, cluster access, 
          and observability settings based on the following context and inputs. """

          MESSAGE user Is there any pod in a non healthy status?
          MESSAGE assistant yes, here's a list of pods in each namespace that are not in healthy status
          MESSAGE user Can you list namespaces I have in my cluster?
          MESSAGE assistant yes, here it is the list of namespaces
    run: 
      - suseai-k8s
```
Once we are ready, let's commit and observe...our Open-WebUI will now show a nice custom model we may use immediately.
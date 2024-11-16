Apply code:
`terraform init`
`terraform plan -out=deploy.tfplan`
`terraform apply deploy.tfplan`

Init FluxCD:
```
flux bootstrap github \
  --owner=berserker5000 \
  --repository=Maklai-Hetzner \
  --branch=master \
  --path=./clusters/maklai \
  --personal
```

Connect to K8s cluster:
`kubectl config use-context ./kubeconfig`


TODO:
- Create github action to put API keys on-fly
- Create outputs to put values from terraform to k8s manifests
- Create Makefile for docker image build and push to ECR/registry
- Fix nginx ingress controller with Hetzner (to create services automatically)
- Github action to trigger flux deploy
# Azure AKS Final Project - Movie Library
## Requirents:
- install kubectl 
- install helm
- install AZ CLI
- connect to AZ - AZ Login

## Infrastracture deployment:
### Deploy Terraform
#### Deployes Resource Group, AKS Cluster with all Namespaces and installs Jenkins, Argocd, Grafana and Prometheus using helm Charts
- terraform init
- terraform plan
- terraform apply 

### Deploy Argo:
 - kubectl apply -n cicd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

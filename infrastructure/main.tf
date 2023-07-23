#Create Azure Resource Group
resource "azurerm_resource_group" "rg-finalproj" {
  name     = var.resource_group_name
  location = var.rg-location
}
#Create Cluster in AKS
data "azuread_client_config" "current" {}
resource "azuread_application" "finalprojAD" {
  display_name = "finalprojAD"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "terraform" {
  application_id               = azuread_application.finalprojAD.application_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_kubernetes_cluster.k8s.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.terraform.id
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg-finalproj.location
  name                = var.aks_name
  resource_group_name = azurerm_resource_group.rg-finalproj.name
  dns_prefix          = "finalproj"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = 1
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}

#Configure Kubernetes Provider
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}
#Configure Helm Provider
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}
#Create Namesapce cicd
resource "kubernetes_namespace" "cicd" {
  metadata {
    name = "cicd"
  }
}
#Create Namesapce monitoring
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
#Create Namesapce dev
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
#Create Namesapce stage
resource "kubernetes_namespace" "stage" {
  metadata {
    name = "stage"
  }
}
#Create Namesapce Prod
resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}
#Create Namesapce Database
resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
  }
}
#Install Prometheus using Helm
resource "helm_release" "prometheus" {
  chart = "prometheus"
  name = "prometheus"
  namespace = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "15.5.3"
  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }
  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
#Install Grafana using Helm
resource "helm_release" "grafana" {
  name = "grafana"
  namespace = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
    set {
    name  = "service.type"
    value = "LoadBalancer"
  }
}
#Install Jenkins using Helm
resource "helm_release" "jenkins" {
  name      = "jenkins"
  namespace = "cicd"
  repository = "https://charts.jenkins.io"
  chart     = "jenkins"
  set {
    name  = "controler.serviceType"
    value = "LoadBalancer"
  }
  set {
    name = "controller.installPlugins"
    value = "kubernetes:1.31.3 workflow-aggregator:2.6 git:4.10.2 configuration-as-code:1414.v878271fc496f blueocean:1.27.4"
  }

  set {
    name = "agent.image"
    value = "itsvictorfy/final_proj"
  }

  set {
    name = "agent.tag"
    value = "jenkinsSlave"
  }

  set {
    name  = "controler.targetPort"
    value = 80
  }

}
resource "helm_release" "argocd" {
  name = "argocd"
  namespace = "cicd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  set {
    name = "service.type"
    value = "LoadBalancer"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}
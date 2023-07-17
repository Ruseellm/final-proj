resource "azurerm_resource_group" "rg-finalproj" {
  name     = var.resource_group_name
  location = var.rg-location
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
    node_count = 2
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

provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.k8s.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate)
  }
}
resource "kubernetes_namespace" "cicd" {
  metadata {
    name = "cicd"
  }
}
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}
resource "kubernetes_namespace" "stage" {
  metadata {
    name = "stage"
  }
}
resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}
resource "kubernetes_namespace" "database" {
  metadata {
    name = "database"
  }
}
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

resource "helm_release" "grafana" {
  name = "grafana"
  namespace = "monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart = "grafana"
    set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.externalPort"
    value = 8080
  }
}

resource "helm_release" "jenkins" {
  name = "jenkins"
  namespace = "cicd"
  repository = "https://charts.jenkins.io"
  chart = "jenkins"
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "protocolHttp"
    value = "true"
  }

  set {
    name  = "service.externalPort"
    value = 80
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
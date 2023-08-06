# Kind Cluster

## Requirements
1. Go Installed
2. Docker/Podman Installed

## Installation
```
go install sigs.k8s.io/kind@v0.20.0
```

## Seetting up the cluster
```
kind create cluster --config kind-image.yaml 
```
* Add the --name flag to change the cluster's context name.

## Cleanup
- Easy as creating the cluster, simply run the following command:
```
kind delete cluster
```
* if the flag --name is not specified, kind will use the default cluster context name which is "kind" and delete that cluster.
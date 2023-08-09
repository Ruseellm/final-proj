mkdir -p vic-jenkins-helm
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm pull jenkins/jenkins -d vic-jenkins-helm/charts
helm package vic-jenkins-helm/ -d vic-jenkins-helm/
docker login 
helm push registry-1.docker.io/itsvictorfy/jenkins:v0.1
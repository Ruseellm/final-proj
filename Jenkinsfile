pipeline {
  agent any
  stages {
    stage('error') {
      steps {
        echo 'Install Docker'
        sh '''sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get -y install docker-ce
sudo systemctl start docker
sudo usermod -aG docker $USER
'''
        echo 'Docker Login'
        sh '''docker login -u $DOCKER_USER -p $DOCKER_PASS
'''
        echo 'Docker Build'
        sh '''docker build ./application/ --tag itsvictorfy/dropit:latest
'''
        echo 'Docker Push'
        sh 'docker push itsvictorfy/dropit'
      }
    }

  }
  environment {
    DOCKER_USER = 'itsvictorfy'
    DOCKER_PASS = 'Uheyur1252@$'
  }
}
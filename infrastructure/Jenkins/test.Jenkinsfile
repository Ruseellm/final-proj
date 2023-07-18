pipeline {
    agent {
      kubernetes {
          inheritFrom 'maven'
      }
    }
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Build') {
            steps {
                sh 'echo Built'
            }
        }
        stage('Test'){
            steps {
                sh 'echo Test'
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo Deploy'
            }
        }
    }
}
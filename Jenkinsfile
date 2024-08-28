REGISTRY_ID = 'crpu00qg6bm5s01t253q'

pipeline {

    agent {
        label "linux"
    }

    stages {
        stage('Login docker in registry') {
            steps {
                withCredentials([string(credentialsId: 'registry_token', variable: 'TOKEN')]) {
                    sh """
                      set +x
                      docker login -u iam -p ${TOKEN} cr.yandex
                    """
                }
            }
        }

        stage('Build') {
            steps {
                sh "docker build . -t cr.yandex/${REGISTRY_ID}/devops-netology-diploma-app:0.0.1"
                sh "docker pushh ${REGISTRY_ID}/devops-netology-diploma-app:0.0.1"
            }
        }

        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
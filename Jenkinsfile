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
                sh "docker build --no-cache -t cr.yandex/${REGISTRY_ID}/devops-netology-diploma-app:0.0.1 ."
                sh "docker push cr.yandex/${REGISTRY_ID}/devops-netology-diploma-app:0.0.1"
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }

        stage('Clean') { steps {
                sh 'docker rmi $(docker images -a -q)'
            }
        }

    }
}
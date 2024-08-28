REGISTRY_ID = 'crpu00qg6bm5s01t253q'
REGISTRY_URL = 'cr.yandex'
MAJOR = '0'
MINOR = '0'

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
                      docker login -u iam -p ${TOKEN} ${REGISTRY_URL}
                    """
                }
            }
        }

        stage('Build') {
            steps {
                sh "docker build --no-cache -t ${REGISTRY_URL}/${REGISTRY_ID}/devops-netology-diploma-app:${MAJOR}.${MINOR}.${currentBuild.number} ."
                sh "docker push ${REGISTRY_URL}/${REGISTRY_ID}/devops-netology-diploma-app:${MAJOR}.${MINOR}.${currentBuild.number}"
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }

        stage('Clean') { 
            steps {
                cleanWs()
                sh 'docker system prune -a -f'
            }
        }

    }
}
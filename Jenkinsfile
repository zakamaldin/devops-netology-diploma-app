REGISTRY_ID = 'crp8a4pr1naq2et8gafj'
REGISTRY_URL = 'cr.yandex'
MAJOR = '0'
MINOR = '0'

APP_NAME = 'devops-netology-diploma-app'
IMAGE_URL = "${REGISTRY_URL}/${REGISTRY_ID}/${APP_NAME}"
IMAGE_TAG = "${MAJOR}.${MINOR}.${currentBuild.number}"

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
                echo "${env.BRANCH_NAME}"
                echo "${env.TAG_NAME}"
                sh "docker build --no-cache -t ${IMAGE_URL}:${IMAGE_TAG} ."
                sh "docker push ${IMAGE_URL}:${IMAGE_TAG}"
            }
        }

        stage('Deploy') {
            steps {
                echo 'Check connect to k8s cluster'
                sh "kubectl cluster-info"
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
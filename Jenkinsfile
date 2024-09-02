REGISTRY_URL = 'cr.yandex'
MAJOR = '0'
MINOR = '0'

APP_NAME = 'devops-netology-diploma-app'
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
                withCredentials([string(credentialsId:'registry_id', variable: 'REGISTRY_ID')]) {
                    script{
                        def tag = sh(returnStdout: true, script: "git tag --points-at HEAD | tail -n 1").trim()
                        if (tag.length() > 0) {
                            IMAGE_TAG = tag
                        }
                        def IMAGE_URL = "${REGISTRY_URL}/${REGISTRY_ID}/${APP_NAME}"
                        sh "docker build --no-cache -t ${IMAGE_URL}:${IMAGE_TAG} ."
                        sh "docker push ${IMAGE_URL}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Check connect to k8s cluster'
                sh "kubectl cluster-info"

                echo "Update helm chart values with new version of image"
                withCredentials([string(credentialsId:'registry_id', variable: 'REGISTRY_ID')]) {
                    script { 
                        def values = readYaml file : 'diploma-helm/values.yaml'
                        values['image']['tag'] = IMAGE_TAG
                        values['repository']['id'] = REGISTRY_ID
                        writeYaml file: 'diploma-helm/values.yaml' , data: values
                    }
                }
                
                echo 'Deploy app'
                sh "helm upgrade -i diploma-1 diploma-helm"

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
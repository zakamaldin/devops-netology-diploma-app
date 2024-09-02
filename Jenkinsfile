import groovy.yaml.YamlSlurper
import groovy.yaml.YamlBuilder

REGISTRY_URL = 'cr.yandex'
MAJOR = '0'
MINOR = '0'

APP_NAME = 'devops-netology-diploma-app'
IMAGE_TAG = "${MAJOR}.${MINOR}.${currentBuild.number}"

pipeline {

    agent {
        label "linux"
    }
    withCredentials([string(credentialsId:'registry_id', variable: 'REGISTRY_ID')]) {
        IMAGE_URL = "${REGISTRY_URL}/${REGISTRY_ID}/${APP_NAME}"
    
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
                    script{
                        def tag = sh(returnStdout: true, script: "git tag --points-at HEAD | tail -n 1").trim()
                        if (tag.length() > 0) {
                            IMAGE_TAG = tag
                        }
                    }

                    sh "docker build --no-cache -t ${IMAGE_URL}:${IMAGE_TAG} ."
                    sh "docker push ${IMAGE_URL}:${IMAGE_TAG}"
                }
            }

            stage('Deploy') {
                steps {
                    echo 'Check connect to k8s cluster'
                    sh "kubectl cluster-info"

                    echo "Update helm chart values with new version of image"
                    script { 
                        def slurper = new YamlSlurper()
                        def builder = new YamlBuilder()
                        def yaml_file = new File('values.yaml').text
                        def values = slurper.parseText(yaml_file)

                        values['image']['tag'] = IMAGE_TAG
                        values['repository']['id'] = REGISTRY_ID  
                        new File('values.yaml').text = builder(values).toString()
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
}
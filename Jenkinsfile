pipeline {
    agent any

    environment {
        BASE_IMAGE_NAME = "web_app"
        CONSUL_URL = "http://consul:8500/v1/kv"
        TARGET_CONF_FILE = 'fe.conf'
        CONFIG_PATH = '/path/to/conf.d'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/quyvuacn/cicd.git'
            }
        }

        stage('Get Current Color') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'consul_master_token', variable: 'token')]) {
                        def currentColor = sh(script: "curl -H 'X-Consul-Token: ${token}' '${env.CONSUL_URL}/current_color?raw'", returnStdout: true).trim().replaceAll('"', '')
                        env.CURRENT_COLOR = currentColor ?: "blue"
                    }
                    echo "Current color is ${env.CURRENT_COLOR}"
                }
            }
        }

        stage('Build and Run new Image') {
            steps {
                script {
                    env.NEXT_COLOR = env.CURRENT_COLOR == "blue" ? "green" : "blue"
                    env.OLD_IMAGE = "${env.BASE_IMAGE_NAME}_${env.CURRENT_COLOR}"
                    env.NEW_IMAGE = "${env.BASE_IMAGE_NAME}_${env.NEXT_COLOR}"

                    echo "Next color will be: ${env.NEXT_COLOR}"
                    echo "Building and running image: ${env.NEW_IMAGE}"

                    sh """
                    docker-compose stop ${env.NEW_IMAGE} || true
                    docker-compose rm -f ${env.NEW_IMAGE}
                    docker-compose up -d --build ${env.NEW_IMAGE}
                    """
                }
            }
        }

        stage('Check Health') {
            steps {
                script {
                    sh "chmod +x ./jenkins-jobs/health-check.sh"
                    def checkResult = sh(script: "./jenkins-jobs/health-check.sh http://${env.BASE_IMAGE_NAME}_${env.NEXT_COLOR} 2", returnStdout: true).trim()

                    if (checkResult == "OK") {
                        echo "http://${env.BASE_IMAGE_NAME}_${env.NEXT_COLOR} is healthy!"
                    } else {
                        error "http://${env.BASE_IMAGE_NAME}_${env.NEXT_COLOR} is unhealthy!"
                    }
                }
            }
        }

        stage('Switching to new color') {
            steps {
                script {
                    sh "chmod +x ./jenkins-jobs/replace-env.sh"
                    sh "./jenkins-jobs/replace-env.sh ${env.CURRENT_COLOR} ${env.TARGET_CONF_FILE}"
                }
            }
        }

        stage('Update Config') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'consul_master_token', variable: 'token')]) {
                        def putResult = sh(script: "curl -X PUT -H 'X-Consul-Token: ${token}' -d '${env.NEXT_COLOR}' '${env.CONSUL_URL}/current_color'", returnStdout: true).trim()
                        echo "Update result: ${putResult}"
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                sh "docker-compose stop ${env.OLD_IMAGE} || true"
                echo 'Deployment successful!'
            }
        }
        failure {
            echo 'Deployment failed!'

            script {
                withCredentials([string(credentialsId: 'consul_master_token', variable: 'token')]) {
                    sh(script: "curl -X PUT -H 'X-Consul-Token: ${token}' -d '${env.CURRENT_COLOR}' '${env.CONSUL_URL}/current_color'")
                }

                sh "docker-compose stop ${env.NEXT_COLOR} || true"
                sh "docker start ${env.OLD_IMAGE}"
            }
        }
    }
}

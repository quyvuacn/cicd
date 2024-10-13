pipeline {
    agent any

    environment {
        BASE_SERVICE_NAME = "web_app"
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
                        env.CURRENT_COLOR = currentColor
                    }
                    echo "Current color is ${env.CURRENT_COLOR}"
                }
            }
        }

        stage('Build and Run new Image') {
            steps {
                script {
                    echo "Current color is ${env.CURRENT_COLOR}"
                    env.NEXT_COLOR = env.CURRENT_COLOR == "blue" ? "green" : "blue"
                    def service = "${env.BASE_SERVICE_NAME}_${env.NEXT_COLOR}"
                    echo "Next color will be: ${env.NEXT_COLOR}"
                    echo "Building and running service: ${service}"

                    sh """
                    docker-compose stop ${service} || true
                    docker-compose up -d --build ${service}
                    """
                }
            }
        }

        stage('Check Health') {
            steps {
                script {
                    sh "chmod +x ./jenkins-jobs/health-check.sh"
                    def checkResult = sh(script: "./jenkins-jobs/health-check.sh http://${env.BASE_SERVICE_NAME}_${env.NEXT_COLOR} 2", returnStdout: true).trim()

                    if (checkResult == "OK") {
                        echo "Service is healthy!"
                    } else {
                        error "Service is unhealthy!"
                    }
                }
            }
        }

        stage('Switching to new color') {
            steps {
                script {
                    def oldService = "${env.BASE_SERVICE_NAME}_${env.CURRENT_COLOR}"

                    sh "chmod +x ./jenkins-jobs/replace-env.sh"
                    sh "./jenkins-jobs/replace-env.sh ${env.CURRENT_COLOR} ${env.TARGET_CONF_FILE}"
                    sh "docker-compose stop ${oldService} || true"
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
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}

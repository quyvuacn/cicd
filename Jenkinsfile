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
                    def nextColor = env.CURRENT_COLOR == "blue" ? "green" : "blue"
                    def service = "${env.BASE_SERVICE_NAME}_${nextColor}"
                    echo "Next color will be: ${nextColor}"
                    echo "Building and running service: ${service}"

                    sh"""
                    docker-compose stop ${service}
                    docker-compose up -d --build ${service}
                    """
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

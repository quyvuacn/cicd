pipeline {
    agent any

    environment {
        BASE_SERVICE_NAME="web_app"
        CURRENT_COLOR = "blue"
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
                        def result = sh(script: "curl -H 'X-Consul-Token: ${token}' '${env.CONSUL_URL}/active_color?raw'", returnStdout: true).trim()
                        env.CURRENT_COLOR = result
                    }
                }
            }
        }

        stage('Build and Run new Image') {
            steps {
                script {
                    def nextColor = env.CURRENT_COLOR == 'blue' ? 'green' : 'blue'
                    def service = "${env.BASE_SERVICE_NAME}_${nextColor}"
                    echo "Next color will be: ${nextColor}"
                    echo "Building and running service: ${service}"

                    sh """
                        // docker compose up -d --build  ${service}
                        ls
                    """
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

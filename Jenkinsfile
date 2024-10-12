pipeline {
    agent any

    environment {
        CURRENT_COLOR = 'blue'
        TARGET_FILE = 'fe.conf'
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
                    def consulToken = credentials('consul_master_token')
                    def activeColor = sh(script: "consul kv get -token ${consulToken} active_color", returnStdout: true).trim()
                    echo "Current active color: ${activeColor}"

                    env.CURRENT_COLOR = activeColor
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

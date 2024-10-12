pipeline {
    agent any

    environment {
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
                    withCredentials([string(credentialsId: 'consul_master_token', variable: 'token')]) {
                        def command = "consul kv get -token ${token} active_color"
                        def result = sh(script: command, returnStdout: true)
                        echo "Current active color: ${result}"
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

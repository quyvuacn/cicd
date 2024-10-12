pipeline {
    agent any

    environment {
        ACTIVE_COLOR = 'blue'
        DOCKER_IMAGE_NAME = 'your-angular-app'
        DOCKER_NETWORK = 'app-network'
        TARGET_FILE = 'fe.conf'
        CONFIG_PATH = '/path/to/conf.d'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/quyvuacn/cicd.git'
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

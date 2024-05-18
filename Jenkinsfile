pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                echo 'Cloneing...'
                sh 'git pull origin main'
            }
        }
    }
}

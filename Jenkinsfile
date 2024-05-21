pipeline {
    agent any

    environment {
        DOCKER_USERNAME = "quyvuacn"
        DOCKER_REPO = "cicd_example"
        DOCKER_TAG = "latest"
        DOCKERFILE = "Dockerfile"
    }

    stages {
        stage('Pull') {
            steps {
                git branch: 'main', credentialsId: 'credential_github', url: 'https://github.com/quyvuacn/cicd'
            }
        }

        stage('Package and Build') {
            steps {
                withDockerRegistry(credentialsId: 'credential_dockerhub', url: 'https://index.docker.io/v1/') {
                    sh 'docker build -f "$DOCKERFILE" -t ${DOCKER_USERNAME}/${DOCKER_REPO}:${DOCKER_TAG} .'
                    sh 'docker push ${DOCKER_USERNAME}/${DOCKER_REPO}:${DOCKER_TAG}'


                    sh "docker stop ${DOCKER_REPO} || true"
                    sh "docker rm ${DOCKER_REPO} || true"
                    sh "docker run -d --name ${DOCKER_REPO} -p 3000:3000 ${DOCKER_USERNAME}/${DOCKER_REPO}:${DOCKER_TAG}"
                }
            }
        }
    }
}

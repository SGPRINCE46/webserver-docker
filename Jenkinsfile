pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-website"
        IMAGE_TAG  = "latest"
        CONTAINER_NAME = "my-website-container"
        HOST_PORT  = "8081"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Stop & Remove Old Container') {
            steps {
                echo 'Removing old container if exists...'
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                '''
            }
        }

        stage('Run New Container') {
            steps {
                echo 'Starting new container...'
                sh '''
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${HOST_PORT}:80 \
                        ${IMAGE_NAME}:${IMAGE_TAG}
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying container is running...'
                sh 'docker ps | grep ${CONTAINER_NAME}'
            }
        }
    }

    post {
        success {
            echo 'Deployment successful! Website is live.'
        }
        failure {
            echo 'Pipeline failed. Check the logs.'
        }
    }
}
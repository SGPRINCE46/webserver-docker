// ─────────────────────────────────────────────────────────
// Jenkinsfile — CI/CD Pipeline
// Project : Docker Web Server via Jenkins
// Flow    : GitHub → Build → Test → Push → Deploy
// ─────────────────────────────────────────────────────────

pipeline {
    agent any

    // ── Environment Variables ──────────────────────────────
    environment {
        IMAGE_NAME      = "my-webserver"
        IMAGE_TAG       = "${BUILD_NUMBER}"          // unique tag per build
        CONTAINER_NAME  = "webserver-container"
        HOST_PORT       = "8080"
        CONTAINER_PORT  = "80"
        DOCKER_HUB_USER = "sgprince"  // ← change this
        REGISTRY        = "${DOCKER_HUB_USER}/${IMAGE_NAME}"
    }

    // ── Triggers ───────────────────────────────────────────
    triggers {
        // Poll GitHub every 5 minutes (or use webhooks — see README)
        pollSCM('H/5 * * * *')
    }

    stages {

        // ── STAGE 1: Checkout ──────────────────────────────
        stage('1 · Checkout from GitHub') {
            steps {
                echo '📥 Pulling latest code from GitHub...'
                checkout scm
                sh 'ls -la'
            }
        }

        // ── STAGE 2: Build Docker Image ────────────────────
        stage('2 · Build Docker Image') {
            steps {
                echo "🐳 Building Docker image: ${REGISTRY}:${IMAGE_TAG}"
                sh """
                    docker build \
                        -t ${REGISTRY}:${IMAGE_TAG} \
                        -t ${REGISTRY}:latest \
                        .
                """
            }
        }

        // ── STAGE 3: Test Container ────────────────────────
        stage('3 · Test Container') {
            steps {
                echo '🧪 Running smoke test on container...'
                sh """
                    # Start a temporary test container
                    docker run -d --name test-container \
                        -p 9090:${CONTAINER_PORT} \
                        ${REGISTRY}:${IMAGE_TAG}

                    # Wait for nginx to start
                    sleep 3

                    # Hit the health endpoint
                    HTTP_CODE=\$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090)
                    echo "HTTP Response Code: \$HTTP_CODE"

                    # Cleanup test container
                    docker stop test-container && docker rm test-container

                    # Fail if not 200
                    if [ "\$HTTP_CODE" != "200" ]; then
                        echo "❌ Smoke test FAILED — HTTP \$HTTP_CODE"
                        exit 1
                    fi
                    echo "✅ Smoke test PASSED"
                """
            }
        }

        // ── STAGE 4: Push to Docker Hub ────────────────────
        stage('4 · Push to Docker Hub') {
            steps {
                echo '📤 Pushing image to Docker Hub...'
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-credentials',  // set in Jenkins → Manage Credentials
                        usernameVariable: 'DOCKER_USER',
                        passwordVariable: 'DOCKER_PASS'
                    )
                ]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                        docker push ${REGISTRY}:${IMAGE_TAG}
                        docker push ${REGISTRY}:latest
                    """
                }
            }
        }

        // ── STAGE 5: Deploy Container ──────────────────────
        stage('5 · Deploy Web Server') {
            steps {
                echo '🚀 Deploying web server container...'
                sh """
                    # Stop & remove old container if running
                    docker stop ${CONTAINER_NAME} 2>/dev/null || true
                    docker rm   ${CONTAINER_NAME} 2>/dev/null || true

                    # Run the new container
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        --restart unless-stopped \
                        -p ${HOST_PORT}:${CONTAINER_PORT} \
                        ${REGISTRY}:${IMAGE_TAG}

                    echo "✅ Container running on port ${HOST_PORT}"
                    docker ps | grep ${CONTAINER_NAME}
                """
            }
        }

        // ── STAGE 6: Cleanup ───────────────────────────────
        stage('6 · Cleanup Old Images') {
            steps {
                echo '🧹 Removing dangling Docker images...'
                sh 'docker image prune -f'
            }
        }
    }

    // ── Post Actions ───────────────────────────────────────
    post {
        success {
            echo "🎉 Pipeline SUCCEEDED — Build #${BUILD_NUMBER} is live on port ${HOST_PORT}"
        }
        failure {
            echo "💥 Pipeline FAILED — Check the logs above"
            // Optional: sh 'curl -X POST <your-slack-webhook-url> -d ...'
        }
        always {
            echo '📋 Pipeline finished. Cleaning workspace...'
            cleanWs()
        }
    }
}

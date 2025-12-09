pipeline {
    agent any

    environment {
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb"
        PORT = "5000"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                """
            }
        }

        stage('Stop Old Container') {
            steps {
                sh """
                    if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                        docker stop ${CONTAINER_NAME}
                    fi
                    if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                        docker rm ${CONTAINER_NAME}
                    fi
                """
            }
        }

        stage('Run New Container') {
            steps {
                sh """
                    docker run -d --name ${CONTAINER_NAME} \
                    -p ${PORT}:${PORT} \
                    ${IMAGE_NAME}:${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        success {
            echo "Application deployed successfully!"
            echo "Access it at: http://<SERVER-IP>:${PORT}"
        }
    }
}


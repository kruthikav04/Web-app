pipeline {
    agent any

    environment {
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb"
        PORT = "5001"           // This is the app port
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        SSH_CRED = "vm-70-ssh"
        SSH_PORT = "22"         // Correct SSH port
    }

    stages {
        stage('Checkout Code') {
            steps { checkout scm }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
            }
        }

        stage('Save Docker Image') {
            steps {
                sh "docker save ${IMAGE_NAME}:${BUILD_NUMBER} -o image.tar"
            }
        }

        stage('Copy Image to VM 70') {
            steps {
                sshagent([SSH_CRED]) {
                    sh "scp -P ${SSH_PORT} image.tar ${DEPLOY_USER}@${DEPLOY_HOST}:/tmp/image.tar"
                }
            }
        }

        stage('Deploy on VM 70') {
            steps {
                sshagent([SSH_CRED]) {
                    sh """
                    ssh -p ${SSH_PORT} ${DEPLOY_USER}@${DEPLOY_HOST} '
                        docker load -i /tmp/image.tar && \
                        docker stop ${CONTAINER_NAME} || true && \
                        docker rm ${CONTAINER_NAME} || true && \
                        docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} -e PORT=${PORT} ${IMAGE_NAME}:${BUILD_NUMBER}
                    '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "App deployed on VM ${DEPLOY_HOST} successfully!"
            echo "Access it at: http://${DEPLOY_HOST}:${PORT}"
        }
        failure {
            echo "Deployment failed! Check the logs."
        }
    }
}

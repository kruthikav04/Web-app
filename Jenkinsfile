pipeline {
    agent any

    environment {
        SSH_CRED = "vm-ssh-1"
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb"
        PORT = "5001"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build -t ${IMAGE_NAME}:latest .
                """
            }
        }

        stage('Deploy to VM 70') {
            steps {
                sshagent([SSH_CRED]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                            docker stop ${CONTAINER_NAME} || true &&
                            docker rm ${CONTAINER_NAME} || true &&
                            docker rmi ${IMAGE_NAME}:latest || true &&
                            exit
                        '
                    """

                    // Copy image to remote VM
                    sh """
                        docker save ${IMAGE_NAME}:latest | ssh ${DEPLOY_USER}@${DEPLOY_HOST} docker load
                    """

                    // Run container again
                    sh """
                        ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                            docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}:latest
                        '
                    """
                }
            }
        }
    }
}

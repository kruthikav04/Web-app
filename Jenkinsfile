pipeline {
    agent any

    environment {
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb"
        PORT = "5001"
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        SSH_CRED = "vm-70-ssh"
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

        stage('Save Docker Image') {
            steps {
                sh """
                    docker save ${IMAGE_NAME}:${BUILD_NUMBER} -o image.tar
                """
            }
        }

        stage('Copy Image to VM 70') {
            steps {
                sshagent([SSH_CRED]) {
                    sh """
                        scp image.tar ${DEPLOY_USER}@${DEPLOY_HOST}:/tmp/image.tar
                    """
                }
            }
        }

        stage('Deploy on VM 70') {
            steps {
                sshagent([SSH_CRED]) {
                    sh """
                        ssh ${DEPLOY_USER}@${DEPLOY_HOST} '
                            docker load -i /tmp/image.tar &&
                            if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                                docker stop ${CONTAINER_NAME};
                            fi &&
                            if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                                docker rm ${CONTAINER_NAME};
                            fi &&
                            docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}:${BUILD_NUMBER}
                        '
                    """
                }
            }
        }
    }

    post {
        success {
            echo "App deployed on VM 10.4.4.70 successfully!"
            echo "Access it at: http://10.4.4.70:${PORT}"
        }
    }
}


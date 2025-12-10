pipeline {
    agent any

    environment {
        SSH_CRED = "vm-ssh-1"
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb-docker"
        DOCKER_PORT = "5002"   // Docker container host port
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout([$class: 'GitSCM', 
                    branches: [[name: 'dev']], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/kruthikav04/Web-app.git',
                        credentialsId: SSH_CRED
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                // Build Docker from the Jenkins workspace
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Deploy Docker Container to VM 70') {
            steps {
                sshagent([SSH_CRED]) {
                    // Stop & remove old Docker container & image on VM 70
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                        docker stop ${CONTAINER_NAME} || true &&
                        docker rm ${CONTAINER_NAME} || true &&
                        docker rmi ${IMAGE_NAME}:latest || true
                    '
                    """

                    // Copy Docker image to VM 70
                    sh "docker save ${IMAGE_NAME}:latest | ssh ${DEPLOY_USER}@${DEPLOY_HOST} docker load"

                    // Run container on VM 70 port 5002
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                        docker run -d --name ${CONTAINER_NAME} -p ${DOCKER_PORT}:5001 ${IMAGE_NAME}:latest
                    '
                    """
                }
            }
        }
    }
}

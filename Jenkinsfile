pipeline {
    agent any

    environment {
        SSH_CRED = "vm-ssh-1"
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb-docker"
        DOCKER_PORT = "5001"   // Host port for Docker container
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
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Deploy Docker Container') {
            steps {
                sshagent([SSH_CRED]) {
                    // Stop & remove old container
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                        docker rm -f ${CONTAINER_NAME} || true
                    '
                    """

                    // Load new Docker image
                    sh "docker save ${IMAGE_NAME}:latest | ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'docker load'"

                    // Run new container on port 5001
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


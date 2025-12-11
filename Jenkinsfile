pipeline {
    agent any

    environment {
        SSH_CRED = "vm-ssh-1"
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb-docker"
<<<<<<< HEAD
        DOCKER_PORT = "5001"   // Host port for Docker container
=======
        DOCKER_PORT = "5001"   // Host port changed to 5001
>>>>>>> b48478595de6a7abb927f9177235d96c0a2b9136
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

                    // Stop + Remove old container on VM 70
                    sh """
                    ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
<<<<<<< HEAD
                        docker rm ${CONTAINER_NAME} || true                    
=======
                        docker rm -f ${CONTAINER_NAME} || true
>>>>>>> b48478595de6a7abb927f9177235d96c0a2b9136
                    '
                    """

                    // Load new Docker image into VM
                    sh """
                    docker save ${IMAGE_NAME}:latest | ssh ${DEPLOY_USER}@${DEPLOY_HOST} 'docker load'
                    """

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

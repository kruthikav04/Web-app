pipeline {
    agent any

    environment {
        IMAGE_NAME = "python-webapp"
        CONTAINER_NAME = "pythonweb"
        PORT = "5001"
        DEPLOY_SERVER = "backup_gcp@10.4.4.70"
        DEPLOY_DIR = "/home/backup_gcp/run"
        GIT_REPO = "https://github.com/<your-username>/<your-repo>.git"
    }

    stages {

        stage('Prepare Remote Folder') {
            steps {
                sh """
                    ssh ${DEPLOY_SERVER} "mkdir -p ${DEPLOY_DIR}"
                """
            }
        }

        stage('Clone Repo on VM 70') {
            steps {
                sh """
                    ssh ${DEPLOY_SERVER} "
                        cd ${DEPLOY_DIR} &&
                        rm -rf * &&
                        git clone ${GIT_REPO} .
                    "
                """
            }
        }

        stage('Build Docker Image on VM 70') {
            steps {
                sh """
                    ssh ${DEPLOY_SERVER} "
                        cd ${DEPLOY_DIR} &&
                        docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .
                    "
                """
            }
        }

        stage('Stop Old Container on VM 70') {
            steps {
                sh """
                    ssh ${DEPLOY_SERVER} "
                        if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                            docker stop ${CONTAINER_NAME}
                        fi
                        if [ \$(docker ps -aq -f name=${CONTAINER_NAME}) ]; then
                            docker rm ${CONTAINER_NAME}
                        fi
                    "
                """
            }
        }

        stage('Run New Container on VM 70') {
            steps {
                sh """
                    ssh ${DEPLOY_SERVER} "
                        docker run -d --name ${CONTAINER_NAME} \
                        -p ${PORT}:${PORT} \
                        ${IMAGE_NAME}:${BUILD_NUMBER}
                    "
                """
            }
        }
    }

    post {
        success {
            echo "Application deployed successfully!"
            echo "Access it at: http://10.4.4.70:${PORT}"
        }
    }
}


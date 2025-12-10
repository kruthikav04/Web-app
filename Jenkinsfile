pipeline {
    agent any

    environment {
        DEPLOY_USER = "backup_gcp"
        DEPLOY_HOST = "10.4.4.70"
        DEPLOY_DIR = "/home/backup_gcp/run"
        GIT_URL = "https://github.com/kruthikav04/Web-app.git"  // replace with your repo
        SSH_CRED = "vm-ssh"
    }

    stages {
        stage('Deploy Python App') {
            steps {
                sshagent([SSH_CRED]) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                            mkdir -p ${DEPLOY_DIR} &&
                            cd ${DEPLOY_DIR} &&
                            rm -rf * &&
                            git clone ${GIT_URL} app &&
                            cd app &&
                            pip3 install -r requirements.txt &&
                            nohup python3 app.py > output.log 2>&1 &
                        '
                    """
                }
            }
        }
    }
}

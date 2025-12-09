pipeline {
  agent any

  environment {
    IMAGE_NAME = "kruthikav04/python-webapp" // change to your Docker Hub repo or local name
    IMAGE_TAG  = "${env.BUILD_NUMBER}"
    APP_PORT   = "5000"
    HOST_PORT  = "5000" // change if needed or use env var
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build Image') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('Stop & Remove Old Container') {
      steps {
        // safe stop/remove if exists
        sh """
          docker stop python-webapp || true
          docker rm python-webapp || true
        """
      }
    }

    stage('Run Container') {
      steps {
        sh """
          docker run -d --name python-webapp -p ${HOST_PORT}:${APP_PORT} ${IMAGE_NAME}:${IMAGE_TAG}
        """
      }
    }

    stage('Optional: Push Image') {
      when { expression { return false } } // set true if you want to push. Or configure credentials and set to true
      steps {
        withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DH_USER', passwordVariable: 'DH_PASS')]) {
          sh "echo $DH_PASS | docker login -u $DH_USER --password-stdin"
          sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
        }
      }
    }
  }

  post {
    success {
      echo "App should now be available at: http://${env.NODE_NAME}:${HOST_PORT} (or replace NODE IP)"
    }
    failure {
      echo "Build failed"
    }
  }
}


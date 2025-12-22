pipeline {
    agent any

    tools {
        nodejs 'node18'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }

                stage('Static Analysis') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Run tests') {
            steps {
                sh 'exit 1'
            }
        }
    }

    post {
  failure {
    sh '''
      curl -X POST -H "Content-Type: application/json" \
      -d "{\"content\":\"❌ Jenkins build FAILED: ${JOB_NAME} #${BUILD_NUMBER}\\n${BUILD_URL}\"}" \
      "https://discord.com/api/webhooks/1452556076590563391/c5IyvZ6g1-gA5nehRZyJ7z8dxbJ92KxKzWXR78-OzZFUrwHiUVRRxFaiosVElZ56HbG9"
    '''
  }
}

}

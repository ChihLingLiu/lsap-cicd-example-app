pipeline {
  agent any

  tools { nodejs 'node18' }

  environment {
    DISCORD_WEBHOOK_URL = credentials('discord-webhook')
  }

  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Install dependencies') { steps { sh 'npm install' } }
    stage('Static Analysis') { steps { sh 'npm run lint' } }
    stage('Run tests') { steps { sh 'npm test' } }
  }

  post {
    failure {
      sh '''
        curl -sS -X POST \
          -H "Content-Type: application/json" \
          -d "{\\"content\\":\\"❌ Jenkins build FAILED: ${JOB_NAME} #${BUILD_NUMBER}\\"}" \
          "https://discord.com/api/webhooks/1452556076590563391/c5IyvZ6g1-gA5nehRZyJ7z8dxbJ92KxKzWXR78-OzZFUrwHiUVRRxFaiosVElZ56HbG9"
      '''
    }
  }
}

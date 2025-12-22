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
    stage('Run tests') { steps { sh 'exit 1' } }
  }

  post {
  failure {
    withCredentials([string(credentialsId: 'discord-webhook', variable: 'DISCORD_WEBHOOK')]) {
      sh '''#!/bin/bash
        set +e
        msg="❌ Jenkins build FAILED: ${JOB_NAME} #${BUILD_NUMBER}\\n${BUILD_URL}"
        payload=$(printf '{"content":"%s"}' "$msg")
        curl -sS -X POST \
          -H "Content-Type: application/json" \
          --data "$payload" \
          "$DISCORD_WEBHOOK" || true
      '''
    }
  }
}

}

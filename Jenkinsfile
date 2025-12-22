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
    script {
      def repoUrl = sh(returnStdout: true, script: "git config --get remote.origin.url").trim()
      def msg = "❌ CI FAILED | Name: 劉志翎 | ID: b13705009 | Job: ${env.JOB_NAME} | Build: #${env.BUILD_NUMBER} | Repo: ${repoUrl} | Branch: ${env.BRANCH_NAME} | Status: FAILURE | ${env.BUILD_URL}"

      withCredentials([string(credentialsId: 'discord-webhook', variable: 'DISCORD_WEBHOOK')]) {
        sh """
          curl -sS -X POST \\
            -H "Content-Type: application/json" \\
            -d "{\\"content\\":\\"${msg}\\"}" \\
            "\$DISCORD_WEBHOOK"
        """
      }
    }
  }
}

}

pipeline {
  agent any

  tools { nodejs 'node18' }

  environment {
    DOCKERHUB_REPO = 'ling922/myapp'
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Install dependencies') {
      steps { sh 'npm install' }
    }

    stage('Static Analysis') {
      steps { sh 'npm run lint' }
    }

    stage('Run tests') {
      steps { sh 'npm test' }
    }

    stage('Build & Push (dev)') {
      when { branch 'dev' }
      steps {
        script {
          def tag = "dev-${env.BUILD_NUMBER}"
          def image = "${env.DOCKERHUB_REPO}:${tag}"

          withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                            usernameVariable: 'DOCKER_USER',
                                            passwordVariable: 'DOCKER_PASS')]) {
            sh """
              echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
              docker build -t ${image} .
              docker push ${image}
              docker logout || true
            """
          }
        }
      }
    }

    stage('Deploy & Verify (dev)') {
      when { branch 'dev' }
      steps {
        script {
          def tag = "dev-${env.BUILD_NUMBER}"
          def image = "${env.DOCKERHUB_REPO}:${tag}"

          withCredentials([usernamePassword(credentialsId: 'dockerhub',
                                            usernameVariable: 'DOCKER_USER',
                                            passwordVariable: 'DOCKER_PASS')]) {
            sh """
              echo "\$DOCKER_PASS" | docker login -u "\$DOCKER_USER" --password-stdin
              docker pull ${image}

              docker rm -f dev-app || true
              docker run -d --name dev-app -p 8081:3000 ${image}

              # wait + retry health (最多等 30 秒)
              for i in \$(seq 1 30); do
                if curl -fsS http://localhost:8081/health > /dev/null; then
                  echo "health ok"
                  docker logout || true
                  exit 0
                fi
                sleep 1
              done

              echo "health check failed, printing logs..."
              docker ps -a --filter "name=dev-app" || true
              docker logs --tail 200 dev-app || true
              docker logout || true
              exit 1
            """
          }
        }
      }
    }
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

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
                sh 'npm test'
            }
        }
    }
}

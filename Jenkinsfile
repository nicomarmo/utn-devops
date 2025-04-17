pipeline {
    agent any

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1"
    }

    stages {
        stage('Clone calculator repo') {
            steps {
                git url: 'https://github.com/fedecurto98/utn-devops-calculator-app.git', branch: 'main'
            }
        }

        stage('Restore') {
            steps {
                sh 'dotnet restore'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build --configuration Release'
            }
        }

        stage('Test') {
            steps {
                sh 'dotnet test --no-build --verbosity normal'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
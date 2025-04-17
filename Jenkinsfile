pipeline {
    agent any

    environment {
        DOTNET_CLI_TELEMETRY_OPTOUT = "1"
    }

    stages {
        stage('Clone calculator repo') {
            steps {
                git url: 'https://github.com/fedecurto98/utn-devops-calculator-app.git', 
                     branch: 'main'
            }
        }

        stage('Restore') {
            steps {
                // Especifica la ruta exacta al archivo del proyecto
                sh 'dotnet restore CalculatorApp/CalculatorApp/CalculatorApp.csproj'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build CalculatorApp/CalculatorApp/CalculatorApp.csproj --configuration Release'
            }
        }

        stage('Test') {
            steps {
                sh 'dotnet test CalculatorApp/CalculatorApp.Tests/CalculatorApp.Tests.csproj --verbosity normal'
            }
        }
    }
}
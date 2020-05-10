pipeline {
    agent any
    environment {
       registry = "frankker/testpipeline"
    }
    stages {
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Build') {
            steps {
               sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Build image') {
                app = docker.build("frankker/testpipeline")
            }
            stage('Push image') {
                docker.withRegistry('https://registry.hub.docker.com', 'FrankDockerID') {
                    app.push("${env.BUILD_NUMBER}")
                    app.push("latest")
                }
            }
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}

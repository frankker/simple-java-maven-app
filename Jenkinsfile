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
        stage('Publish') {
             environment {
               registryCredential = 'dockerhub'
             }
             steps{
                 script {
                     def appimage = docker.build   + ":$BUILD_NUMBER"
                     docker.withRegistry( '', registryCredential ) {
                         appimage.push()
                         appimage.push('latest')
                     }
                 }
             }
        }
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}

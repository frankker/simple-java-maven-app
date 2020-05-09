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
                       registryCredential = 'FrankDockerID'
                     }
                     steps{
                         script {
                             def appimage = docker.build registry + ":$BUILD_NUMBER"
                             docker.withRegistry('https://registry.hub.docker.com', registryCredential ) {
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

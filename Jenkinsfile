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
                /* This builds the actual image; synonymous to
                 * docker build on the command line */

                app = docker.build("frankker/testpipeline")
            }
            stage('Push image') {
                /* Finally, we'll push the image with two tags:
                 * First, the incremental build number from Jenkins
                 * Second, the 'latest' tag.
                 * Pushing multiple tags is cheap, as all the layers are reused. */
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

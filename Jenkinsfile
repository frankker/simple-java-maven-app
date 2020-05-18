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
            steps{
              script {
                app = docker.build("frankker/testpipeline")
              }
            }
        }
            stage('Push image') {
                /* Finally, we'll push the image with two tags:
                 * First, the incremental build number from Jenkins
                 * Second, the 'latest' tag.
                 * Pushing multiple tags is cheap, as all the layers are reused. */
                 steps{
                   script {
                     docker.withRegistry('', 'FrankDockerID') {
                       app.push("${env.BUILD_NUMBER}")
                       app.push("latest")
                     }
                   }
                 }
            }

            stage('Kubernetes Deployment'){
              steps {
                sh 'echo "******************kubectl version*********************"'
                withCredentials([string(credentialsId: 'kubernetes-api-server-url', variable: 'mySecretFile')]) {
                                  // some block can be a groovy block as well and the variable will be available to the groovy script
                                  sh '''
                                       echo "This is the directory of the secret file $mySecretFile"
                                       echo "This is the content of the file `cat $mySecretFile`"
                                     '''
                              }
                sh 'kubectl version'
                sh 'kubectl create -f deployment.yaml'
                sh 'echo "******************kubectl version 222*********************"'
              }
            }
/*
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
                     }withKubeConfig
                }
                */
        stage('Deliver') {
            steps {
                sh './jenkins/scripts/deliver.sh'
            }
        }
    }
}

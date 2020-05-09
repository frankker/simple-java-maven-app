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
        /*
        stage('Build Docker Image') {
            container('docker'){
                def app_image_tag = docker.build   + ":$BUILD_NUMBER"
                sh("docker build -f Dockerfile -t ${app_image_tag} .")
            }
        }
        stage('Push Docker Image to Docker Registry') {
            container('docker'){
                def app_image_tag = docker.build   + ":$BUILD_NUMBER"
                withCredentials([[$class: 'UsernamePasswordMultiBinding',
                credentialsId: env.DOCKER_CREDENTIALS_ID,
                usernameVariable: 'USERNAME',
                passwordVariable: 'PASSWORD']]) {
                    docker.withRegistry(env.DOCEKR_REGISTRY, env.DOCKER_CREDENTIALS_ID) {
                        sh("docker push ${app1_image_tag}")
                        sh("docker push ${app2_image_tag}")
                    }
                }
            }
        }
        */
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

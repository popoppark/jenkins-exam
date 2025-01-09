pipeline {
    agent any
    environment {
        BUILD_NUMBER = "v5.0"
        IMAGE_NAME = "192.168.1.183:443/myapp/front"
        HARBOR_CREDENTIALS = credentials('harbor')
        GITHUB_CREDENTIALS = credentials('github-token')
    }
    stages {
        stage('Clone repository') { 
            steps {
                git branch: 'main', 
                    credentialsId: 'github-token', 
                    url: 'https://github.com/popoppark/jenkins-exam.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} ."
                }
            }
        }

        stage('Push Docker Image to Harbor') {
            steps {
                script {
                    sh "echo ${HARBOR_CREDENTIALS_PSW} | docker login -u ${HARBOR_CREDENTIALS_USR} --password-stdin 192.168.1.183:443"
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    sh "git config user.email 'wss2018@gmail.com'"
                    sh "git config user.name 'popoppark'"

                    sh """
                        sed -i 's|image: .*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|g' manifests/cicd-deploy.yaml
                    """
                    sh "git add manifests/cicd-deploy.yaml"
                    sh "git commit -m '[UPDATE] Updated to image version ${BUILD_NUMBER}'"

                    // 수정: Personal Access Token을 URL에 포함하여 Push
                    sh """
                        git push https://${env.GITHUB_CREDENTIALS_USR}:${env.GITHUB_CREDENTIALS_PSW}@github.com/popoppark/jenkins-exam.git main
                    """
                }
            }
        }
    }
    post {
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline execution failed!"
        }
    }
}


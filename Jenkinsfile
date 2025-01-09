peline {
    agent any
    environment {
        BUILD_NUMBER = "v1.0"
        IMAGE_NAME = "192.168.1.183/my-app/heeryun"
        HARBOR_CREDENTIALS = credentials('harbor')
        GITHUB_CREDENTIALS = credentials('github-token')
    }
    stages {
        stage('Clone repository') { // 추가된 stage
            steps {
                git branch: 'main', // 원하는 브랜치 이름
                    credentialsId: 'github-token', // Jenkins에서 설정한 GitHub 인증 ID
                    url: 'https://github.com/popoppark/jenkins-exam.git' // 클론할 레포지토리 URL
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
                    sh "echo ${HARBOR_CREDENTIALS_PSW} | docker login --insecure -u ${HARBOR_CREDENTIALS_USR} --password-stdin 192.168.1.183"
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    sh 'git config user.email "jenkins@yourdomain.com"'
                    sh 'git config user.name "Jenkins CI"'

                    sh """
                        sed -i 's|image: .*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|g' manifests/deployment.yaml
                    """
                    sh "git add manifests/deployment.yaml"
                    sh "git commit -m '[UPDATE] Updated to image version ${BUILD_NUMBER}'"

                    sh "git push https://github-token@github.com/popoppark/jenkins-exam.git main"
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


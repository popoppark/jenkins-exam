pipeline {
    agent any
    environment {
        BUILD_NUMBER = "v1.0"                           // 빌드 번호
        IMAGE_NAME = "192.168.1.183/harbor-4th/my-app"  // Harbor 이미지 이름
        HARBOR_CREDENTIALS = credentials('harbor-crendentials')      // Jenkins에 등록한 Harbor Credentials ID
        GITHUB_CREDENTIALS = credentials('github-token') // GitHub 자격증명
    }
    stages {
        stage('Checkout Source Code') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token', // GitHub 자격증명 ID
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
                    sh "echo ${HARBOR_CREDENTIALS_PSW} | docker login -u ${HARBOR_CREDENTIALS_USR} --password-stdin 192.168.1.183"
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                }
            }
        }
        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    // GitHub에서 Kubernetes manifest 파일 체크아웃
                    sh 'git config user.email "jenkins@yourdomain.com"'
                    sh 'git config user.name "Jenkins CI"'
                    // deployment.yaml의 image 태그 업데이트
                    sh """
                        sed -i 's|image: .*|image: ${IMAGE_NAME}:${BUILD_NUMBER}|g' manifests/deployment.yaml
                    """
                    sh "git add manifests/deployment.yaml"
                    sh "git commit -m '[UPDATE] Updated to image version ${BUILD_NUMBER}'"
                    // GitHub에 커밋 푸시
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


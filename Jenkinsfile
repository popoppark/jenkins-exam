node {
 stage('Clone repository') {
 git credentialsId: 'git_access', url: 'https://github.com/popoppark/jenkins-exam.git'
 }

 stage('Build image') {
 dockerImage = docker.build("heeryun/node-front:1.0")
 }

 stage('Push image') {
 withDockerRegistry([ credentialsId: "docker-token", url: "" ]) {
 dockerImage.push()
 }
 }
}

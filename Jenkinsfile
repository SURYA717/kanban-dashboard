pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t kanban-dashboard:latest .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKERHUB_USER',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    sh '''
                        echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker tag kanban-dashboard:latest "$DOCKERHUB_USER/kanban-dashboard:latest"
                        docker tag kanban-dashboard:latest "$DOCKERHUB_USER/kanban-dashboard:build-${BUILD_NUMBER}"
                        docker push "$DOCKERHUB_USER/kanban-dashboard:latest"
                        docker push "$DOCKERHUB_USER/kanban-dashboard:build-${BUILD_NUMBER}"
                        docker logout
                    '''
                }
            }
        }
        stage('Deploy to EC2') {
            steps {
                sh '''
                    docker pull surya717/kanban-dashboard:latest
                    docker rm -f kanban-dashboard || true
                    docker run -d --name kanban-dashboard -p 8081:8080 --restart unless-stopped surya717/kanban-dashboard:latest
                '''
            }
        }
    }
}

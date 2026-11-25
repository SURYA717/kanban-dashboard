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
    }
}

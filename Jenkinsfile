pipeline {
    agent any 

    environment {
      DOCKER_COMPOSE = "/usr/local/bin/docker-compose"
    }

    stages {
        stage('Preparation') { 
            steps { 
                git 'https://github.com/ptkweller/air-quality-api.git'
            }
        }
        stage('Build'){
            steps {
                sh '${DOCKER_COMPOSE} build' 
            }
        }
        stage('Test'){
            steps {
                sh '${DOCKER_COMPOSE} run --rm --no-deps api go test -v' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'echo hello'
            }
        }
    }
}
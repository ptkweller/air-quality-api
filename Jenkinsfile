pipeline {
    agent any 

    stages {
        stage('Preparation') { 
            steps { 
                git 'https://github.com/ptkweller/air-quality-api.git'
            }
        }
        stage('Build'){
            steps {
                sh 'docker-compose build' 
            }
        }
        stage('Test'){
            steps {
                sh 'docker-compose run --rm --no-deps api go test -v' 
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish'
            }
        }
    }
}
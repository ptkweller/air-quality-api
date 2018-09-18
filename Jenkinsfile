pipeline {
    agent any 

    parameters {
        string(defaultValue: "1.1.1.1", description: 'Server IP Address', name: 'serverIP')
    }

    environment {
      dockerCompose = "/usr/local/bin/docker-compose"
    }

    stages {
        stage('Preparation') { 
            steps { 
                git 'https://github.com/ptkweller/air-quality-api.git'
            }
        }
        stage('Build'){
            steps {
                sh '${dockerCompose} build' 
            }
        }
        stage('Test'){
            steps {
                sh '${dockerCompose} run --rm --no-deps api go test -v' 
            }
        }
        stage('Deploy') {
            steps {
				sh "echo Deploying to server: ${params.serverIP}"
				sh "ssh ec2-user@${params.serverIP} /data/air-quality-api/airQualityApi.sh deploy"
            }
        }
    }
}
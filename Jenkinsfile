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
        stage('Package'){
            steps {
                sh 'rm -f airQualityApi.zip' 
				sh 'zip -r airQualityApi.zip .' 
            }
        }
        stage('Deploy') {
            steps {
				sh "echo Deploying to server: ${params.serverIP}"
				sh "ssh ec2-user@${params.serverIP} /data/air-quality-api/airQualityApi.sh stop"
				sh "ssh ec2-user@${params.serverIP} rm -rf /data/air-quality-api/"
				sh "ssh ec2-user@${params.serverIP} mkdir /data/air-quality-api/"
				sh "aws s3 cp airQualityApi.zip s3://weller-airvisual/airQualityApi.zip"
				sh "ssh ec2-user@${params.serverIP} wget https://s3-eu-west-1.amazonaws.com/weller-airvisual/airQualityApi.zip -P /data/air-quality-api/"
				sh "ssh ec2-user@${params.serverIP} unzip /data/air-quality-api/airQualityApi.zip -d /data/air-quality-api"
				sh "ssh ec2-user@${params.serverIP} /data/air-quality-api/airQualityApi.sh start"
            }
        }
    }
}
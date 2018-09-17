node {
   environment {
      PATH = "$PATH:/usr/local/bin"
   }

   stage('Preparation') {
      git 'https://github.com/ptkweller/air-quality-api.git'
   }
   stage('Build') {
      sh 'whoami'
      sh 'docker-compose build'
   }
   stage('Test') {
      sh 'docker-compose run --rm --no-deps api go test -v'

   }
   stage('Deploy') {
      sh 'echo hello'
   }
}
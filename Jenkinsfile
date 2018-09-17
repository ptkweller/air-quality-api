node {
   stage('Preparation') {
      git 'https://github.com/ptkweller/air-quality-api.git'
   }
   stage('Build') {
      sh 'docker-compose build'
   }
   stage('Test') {
      sh 'docker-compose run --rm --no-deps api go test -v'

   }
   stage('Deploy') {
      sh 'echo hello'
   }
}
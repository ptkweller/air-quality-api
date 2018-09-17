node {
   environment {
      dockerComposePath = "/usr/local/bin"
   }

   stage('Preparation') {
      git 'https://github.com/ptkweller/air-quality-api.git'
   }
   stage('Build') {
      sh '${dockerComposePath}/docker-compose build'
   }
   stage('Test') {
      sh '${dockerComposePath}/docker-compose run --rm --no-deps api go test -v'

   }
   stage('Deploy') {
      sh 'echo hello'
   }
}
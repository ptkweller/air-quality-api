node {
   stage('Preparation') {
      git 'https://github.com/ptkweller/air-quality-api.git'
   }
   stage('Build') {
      bat(/"C:\Program Files\Docker\Docker\resources\bin\docker-compose" build/)
   }
   stage('Test') {
      bat(/"C:\Program Files\Docker\Docker\resources\bin\docker-compose" run --rm --no-deps api go test -v/)

   }
}
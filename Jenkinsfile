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
   stage('Deploy') {
      bat(/"C:\Windows\System32\OpenSSH\ssh" -i C:\Users\peter.weller\Downloads\_Temp\aws\DefaultVPCAccess.pem ec2-user@34.247.86.96 "ls -al \/data\/"/)
   }
}
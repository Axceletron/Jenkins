pipeline {
    agent any
    
    stages {
  stage('cloning git repo') {
    steps{
        git 'https://github.com/Axceletron/Apps'
    }
  }
  stage('Build Image') {
      input {
                message "Should we continue?"
                ok "Yes, we should."
            }
    steps{

      script {
        cd ./app
        docker.build registry + ":$BUILD_NUMBER"
      }
    }}
  
}}
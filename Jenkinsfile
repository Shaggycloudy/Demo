@Library('Shared')_
pipeline{
    agent { label 'dev-server'}
    
    stages{
        stage("Code clone"){
            steps{
                sh "whoami"
            clone("https://github.com/LondheShubham153/django-notes-app.git","main")
            }
        }
        stage("Code Build"){
            steps{
            dockerbuild("notes-app","latest")
            }
        }
        stage("Push to DockerHub"){
            steps{
                dockerpush("dockerHubCreds","notes-app","latest")
            }
        }
        stage("Deploy"){
            steps{
                sh '''
                  if command -v docker-compose >/dev/null 2>&1; then
                    docker-compose -f docker-compose.yml up -d --build
                  else
                    docker compose -f docker-compose.yml up -d --build
                  fi
                '''
            }
        }
        
    }
}

pipeline {
    agent any

    stages {
        stage('Code') {
            steps {
                echo 'This is cloning the code'
                git url: 'https://github.com/omtechops/django-notes-app.git', branch: 'main'
                echo 'My code cloning is done'
            }
        }
        stage('Build') {
            steps {
                echo 'This is build the code'
                sh 'docker build -t my-app:latest .'
                echo 'My code is build'
            }
        }
        stage('Test') {
            steps {
                echo 'This is Testing'
            }
        }
        stage('Deploy') {
            steps {
                echo 'This is deploy the code'
                sh '''
                  docker network create notes-app-nw || true
                  docker rm -f db || true
                  for c in $(docker ps -q --filter name=django_app); do docker rm -f "$c"; done || true
                  for c in $(docker ps -q --filter ancestor=my-app:latest); do docker rm -f "$c"; done || true
                  for c in $(docker ps -q --filter publish=8000); do docker rm -f "$c"; done || true

                  docker run -d \
                    --name db \
                    --network notes-app-nw \
                    -e MYSQL_ROOT_PASSWORD=root \
                    -e MYSQL_DATABASE=test_db \
                    -v "$PWD/data/mysql/db:/var/lib/mysql" \
                    mysql:latest

                  until docker exec db mysqladmin ping -h localhost -uroot -proot >/dev/null 2>&1; do
                    echo 'Waiting for MySQL to start...'
                    sleep 5
                  done

                  docker run --rm \
                    --network notes-app-nw \
                    --env-file .env \
                    my-app:latest \
                    python manage.py migrate --noinput

                  docker run -d \
                    --name django_app \
                    --network notes-app-nw \
                    --env-file .env \
                    -p 8000:8000 \
                    my-app:latest
                '''
            }
        }
    }
}

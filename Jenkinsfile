pipeline {
    agent any

    environment {
        IMAGE_NAME = 'django-notes-app'
        CONTAINER_NAME = 'django_app'
        APP_PORT = '8000'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    def branch = sh(
                        script: '''
                            git ls-remote --heads https://github.com/omtechops/django-notes-app.git 'main' 'master' \
                            | awk '{print $2}' \
                            | sed 's|refs/heads/||' \
                            | head -n 1
                        ''',
                        returnStdout: true
                    ).trim()

                    echo "Detected branch: ${branch}"

                    if (!branch) {
                        error 'No suitable branch found on the remote repository.'
                    }

                    git branch: branch, url: 'https://github.com/omtechops/django-notes-app.git'
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building the Docker image'
                sh "docker build -t ${IMAGE_NAME}:latest ."
            }
        }

        stage('Test') {
            steps {
                echo 'Running Django tests'
                sh "docker run --rm ${IMAGE_NAME}:latest python manage.py test"
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying the Django application'
                sh """
                    docker rm -f ${CONTAINER_NAME} || true
                    docker run -d \
                        --name ${CONTAINER_NAME} \
                        -p ${APP_PORT}:${APP_PORT} \
                        ${IMAGE_NAME}:latest
                """
            }
        }
    }
}

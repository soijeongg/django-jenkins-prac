pipeline {
    agent any

    environment {
        EC2_SSH_CREDENTIALS = credentials('aws_key')
        GIT_REPO_URL = 'https://github.com/soijeongg/django-jenkins-prac.git'
        GIT_BRANCH = 'main'
        DOCKER_IMAGE_NAME = 'study-image'
        CONTAINER_NAME = 'study-container'
        TARGET_EC2_IP = credentials('TARGET_EC2_IP')
        PORT = credentials('PORT')
        DB_ENGINE = credentials('DB_ENGINE')
        DB_NAME = credentials('DB_NAME')
        DB_USER = credentials('DB_USER')
        DB_PASSWORD = credentials('DB_PASSWORD')
        DB_HOST = credentials('DB_HOST')
        DB_PORT = credentials('DB_PORT')
    }
    
    stages {
        stage('Cleanup Workspace') {
            steps {
                // Clean up the workspace to avoid git clone errors
                deleteDir()
            }
        }

        stage('Git Clone') {
            steps {
                // GitHub에서 소스 코드 클론
                sh "git clone -b ${GIT_BRANCH} ${GIT_REPO_URL} ."
            }
        }
        stage('Create .env File') {
            steps {
                sh """
                echo DB_ENGINE=${DB_ENGINE} > .env
                echo DB_NAME=${DB_NAME} >> .env
                echo DB_USER=${DB_USER} >> .env
                echo DB_PASSWORD=${DB_PASSWORD} >> .env
                echo DB_HOST=${DB_HOST} >> .env
                echo DB_PORT=${DB_PORT} >> .env
                echo PORT=${PORT} >> .env
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                    docker build --build-arg DATABASE_HOST=${env.DB_HOST} \
                                --build-arg DATABASE_PORT=${env.DB_PORT} \
                                --build-arg DATABASE_NAME=${env.DB_NAME} \
                                --build-arg DATABASE_USERNAME=${env.DB_USER} \
                                --build-arg DATABASE_PASSWORD=${env.DB_PASSWORD} \
                                --build-arg PORT=${env.PORT} \
                                --build-arg TARGET_EC2_IP=${env.TARGET_EC2_IP} \
                                -t ${env.DOCKER_IMAGE_NAME} .
                    """
            }
        }
        stage('Save Docker Image as TAR') {
            steps {
                sh 'docker save -o ${DOCKER_IMAGE_NAME}.tar ${DOCKER_IMAGE_NAME}'
            }
        }

        stage('Copy Docker Image to Target EC2') {
            steps {
                sshagent(credentials: ['aws_key']) {
                    sh """
                    scp -o StrictHostKeyChecking=no ${DOCKER_IMAGE_NAME}.tar ubuntu@${TARGET_EC2_IP}:/home/ubuntu/
                    ssh -o StrictHostKeyChecking=no ubuntu@${TARGET_EC2_IP} 'chmod 644 /home/ubuntu/${DOCKER_IMAGE_NAME}.tar'
                    """
                }
            }
        }

        stage('Load Docker Image and Run Container on Target EC2') {
            steps {
                sshagent(credentials: ['aws_key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ubuntu@${TARGET_EC2_IP} << EOF
                    docker load -i /home/ubuntu/${DOCKER_IMAGE_NAME}.tar
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${DOCKER_IMAGE_NAME}
                    
                    """
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
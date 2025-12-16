pipeline {
    agent any

    // Utilise l'installation Maven déclarée dans Manage Jenkins -> Tools (nom: maven)
    tools {
        maven 'maven'
    }
    
    environment {
        DOCKER_IMAGE = 'lachgar/pos'
        CONTAINER_NAME = 'test-pos'
        HOST_PORT = '8585'
        CONTAINER_PORT = '8282'
    }
    
    stages {
        stage('Git Clone') {
            steps {
                script {
                    echo 'Récupération du code depuis GitHub...'
                    checkout scm
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    echo 'Compilation et tests avec Maven...'
                    // Maven est installé directement dans le conteneur Jenkins
                    sh 'mvn -version'
                    // Si le projet est dans un sous-dossier, utiliser dir('POV-JAVA')
                    sh 'mvn clean install'
                }
            }
            post {
                success {
                    echo 'Build réussi ✓'
                }
                failure {
                    echo 'Build échoué ✗'
                }
            }
        }
        
        stage('Create Docker Image') {
            steps {
                script {
                    echo 'Création de l\'image Docker...'
                    // Nettoyer l'ancien conteneur s'il existe
                    sh '''
                        docker rm -f ${CONTAINER_NAME} || true
                        docker rmi ${DOCKER_IMAGE} || true
                    '''
                    // Construire l'image Docker
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }
        
        stage('Run Container') {
            steps {
                script {
                    echo 'Lancement du conteneur Docker...'
                    sh """
                        docker run -d \
                            --name ${CONTAINER_NAME} \
                            -p ${HOST_PORT}:${CONTAINER_PORT} \
                            ${DOCKER_IMAGE}
                    """
                }
            }
            post {
                success {
                    echo "Conteneur lancé avec succès sur le port ${HOST_PORT} ✓"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Pipeline terminé'
            // Nettoyer les workspaces si nécessaire
        }
        failure {
            echo 'Pipeline échoué - Vérifier les logs'
        }
    }
}


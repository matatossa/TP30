# 🔧 Solution : Problème Maven "not found"

## Diagnostic

Le pipeline échoue avec `mvn: not found` même après avoir configuré Maven dans Jenkins.

## ✅ Solutions à essayer

### Solution 1 : Vérifier la configuration Maven dans Jenkins

1. **Manage Jenkins** → **Tools** → **Maven installations**
2. Vérifier que :
   - **Name** : exactement `maven` (sensible à la casse)
   - **Install automatically** : ✓ coché
   - **Version** : sélectionnée (ex: 3.9.6)
3. **Save**

### Solution 2 : Utiliser Maven directement dans le conteneur Docker

Si Maven n'est pas disponible via l'outil Jenkins, on peut l'installer directement dans le conteneur Jenkins.

Modifier le `docker-compose.yml` pour installer Maven :

```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
    environment:
      - DOCKER_HOST=unix:///var/run/docker.sock
    networks:
      - jenkins-network
    restart: unless-stopped
    # Installer Maven au démarrage
    command: >
      bash -c "
        apt-get update &&
        apt-get install -y maven &&
        /usr/local/bin/jenkins.sh
      "
```

Puis redémarrer Jenkins :
```bash
docker-compose down
docker-compose up -d
```

### Solution 3 : Utiliser un agent avec Maven pré-installé

Modifier le Jenkinsfile pour utiliser un agent Docker avec Maven :

```groovy
pipeline {
    agent {
        docker {
            image 'maven:3.9.6-eclipse-temurin-17'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    // ... reste du pipeline
}
```

### Solution 4 : Vérifier que le plugin Maven est installé

1. **Manage Jenkins** → **Plugins** → **Installed**
2. Chercher "Maven Integration plugin"
3. Si absent, l'installer depuis **Available plugins**

### Solution 5 : Utiliser le chemin complet de Maven

Modifier le stage Build dans le Jenkinsfile :

```groovy
stage('Build') {
    steps {
        script {
            echo 'Compilation et tests avec Maven...'
            def mvnHome = tool 'maven'
            def mvnCmd = "${mvnHome}/bin/mvn"
            sh "${mvnCmd} -version"
            sh "${mvnCmd} clean install"
        }
    }
}
```

## 🎯 Solution Recommandée (Rapide)

La solution la plus rapide est d'installer Maven directement dans le conteneur Jenkins via docker-compose.


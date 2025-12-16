# TP CI/CD - Pipeline Jenkins pour Spring Boot

Ce projet met en place un pipeline CI/CD complet pour une application Spring Boot utilisant Jenkins, Docker, et ngrok.

## 📋 Table des matières

- [Objectifs](#objectifs)
- [Architecture](#architecture)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [Dépannage](#dépannage)

## 🎯 Objectifs

- Comprendre la différence entre CI (Intégration Continue) et CD (Livraison/Déploiement Continu)
- Installer et configurer Jenkins avec Docker
- Configurer Maven dans Jenkins
- Créer un Pipeline Jenkins pour un projet Spring Boot + Docker
- Exposer Jenkins local à Internet avec ngrok
- Mettre en place un webhook GitHub déclenchant automatiquement le pipeline

## 🏗️ Architecture

### Intégration Continue (CI)
À chaque changement de code, une chaîne automatique :
- Compile le projet
- Exécute les tests
- Signale les erreurs rapidement

**Objectif** : Détecter les problèmes d'intégration le plus tôt possible.

### Livraison / Déploiement Continu (CD)
Automatise la livraison sur des environnements. Dans ce TP :
- Création automatique d'une image Docker
- Exécution d'un conteneur à la fin du pipeline

### Pipeline CI/CD typique
1. Commit/push dans GitHub
2. Jenkins détecte le changement (via webhook)
3. Build + tests
4. Création d'artefacts (jar, image Docker)
5. Déploiement vers un environnement (conteneur Docker local)

## 📦 Prérequis

- Docker et Docker Compose installés
- Compte GitHub avec un dépôt
- Compte ngrok (gratuit)
- Git installé

## 🚀 Installation

### Étape 1 : Démarrer Jenkins avec Docker

```bash
# Démarrer Jenkins
docker-compose up -d

# Vérifier que Jenkins est démarré
docker ps

# Voir les logs
docker-compose logs -f jenkins
```

Jenkins sera accessible sur : `http://localhost:8080`

### Étache 2 : Configuration initiale de Jenkins

1. Ouvrir `http://localhost:8080` dans votre navigateur
2. Récupérer le mot de passe initial :
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Coller le mot de passe dans l'interface Jenkins
4. Installer les plugins recommandés
5. Créer un compte administrateur
6. Arriver sur le Dashboard

### Étape 3 : Configuration de Maven dans Jenkins

1. Dans Jenkins, aller dans **Manage Jenkins** → **Tools**
2. Dans la section **Maven installations**, cliquer sur **Add Maven**
3. Configurer :
   - **Name** : `maven`
   - **Install automatically** : ✓ (coché)
   - **Version** : `3.9.6` (ou dernière version stable)
4. Cliquer sur **Save**

### Étape 4 : Installation des plugins nécessaires

1. **Manage Jenkins** → **Plugins**
2. Installer les plugins suivants (s'ils ne sont pas déjà installés) :
   - **Docker Pipeline**
   - **GitHub Integration**
   - **GitHub plugin**
   - **Pipeline: GitHub**

## ⚙️ Configuration

### Tâche 1 : Créer un nouveau job Pipeline

1. Depuis le Dashboard Jenkins, cliquer sur **New Item**
2. Donner un nom (ex : `my-project`)
3. Sélectionner **Pipeline**
4. Cliquer sur **OK**

### Tâche 2 : Configurer le job Pipeline

Dans l'écran de configuration du job :

1. **Description** : Ajouter "CI/CD Spring Boot + Docker"

2. **GitHub project** :
   - Cocher la case
   - Renseigner l'URL du dépôt GitHub (ex : `https://github.com/votre-username/votre-repo`)

3. **Build Triggers** :
   - Cocher **GitHub hook trigger for GITScm polling**

4. **Pipeline** :
   - **Definition** : `Pipeline script from SCM`
   - **SCM** : `Git`
   - **Repository URL** : URL de votre dépôt GitHub
   - **Branch** : `*/main` (ou `*/master` si votre dépôt utilise master)
   - **Script Path** : `Jenkinsfile`

5. Cliquer sur **Save**

### Tâche 3 : Configuration de ngrok

#### Installation de ngrok

1. Télécharger ngrok depuis https://ngrok.com/download
2. Extraire `ngrok.exe` dans un dossier (ex : `C:\ngrok`)
3. (Optionnel) Ajouter ngrok au PATH Windows

#### Configuration de l'authtoken

1. Créer un compte sur https://ngrok.com
2. Récupérer votre authtoken depuis le dashboard
3. Dans un terminal, exécuter :
   ```bash
   ngrok config add-authtoken <VOTRE_AUTHTOKEN>
   ```

#### Créer le tunnel vers Jenkins

```bash
ngrok http 8080
```

**Important** : Noter l'URL HTTPS publique générée (ex : `https://1f36-196-64-173-133.ngrok-free.app`)

⚠️ **Remarque** : Avec le plan gratuit, l'URL change à chaque redémarrage de ngrok. Il faudra mettre à jour le webhook GitHub.

### Tâche 4 : Créer le webhook dans GitHub

1. Ouvrir votre dépôt GitHub
2. Aller dans **Settings** → **Webhooks**
3. Cliquer sur **Add webhook**
4. Configurer :
   - **Payload URL** : `https://<url-ngrok>/github-webhook/`
   - **Content type** : `application/json`
   - **Events** : Sélectionner "Just the push event"
   - **Active** : ✓ (coché)
5. Cliquer sur **Add webhook**

## 💻 Utilisation

### Test manuel du pipeline

1. Dans Jenkins, ouvrir le job `my-project`
2. Cliquer sur **Build Now**
3. Observer l'exécution du pipeline dans la **Stage View**

### Déclenchement automatique

1. Faire un commit et push dans votre dépôt GitHub :
   ```bash
   git add .
   git commit -m "Test CI/CD"
   git push origin main
   ```
2. Le webhook GitHub déclenchera automatiquement le pipeline Jenkins
3. Vérifier l'exécution dans Jenkins

### Étapes du pipeline

Le pipeline exécute les étapes suivantes :

1. **Git Clone** : Récupération du code depuis GitHub
2. **Build** : Exécution de `mvn clean install`
3. **Create Docker Image** : Fabrication de l'image Docker `lachgar/pos`
4. **Run Container** : Lancement du conteneur sur le port hôte 8585 (conteneur 8282)

## 🔧 Dépannage

### Jenkins ne démarre pas

```bash
# Vérifier les logs
docker-compose logs jenkins

# Redémarrer
docker-compose restart jenkins
```

### Problème avec Docker dans Jenkins

Vérifier que Docker socket est bien monté :
```bash
docker exec jenkins docker ps
```

### Le webhook ne fonctionne pas

1. Vérifier que ngrok est toujours actif
2. Vérifier l'URL du webhook dans GitHub
3. Tester manuellement avec **Build Now** dans Jenkins
4. Vérifier les logs dans **Manage Jenkins** → **System Log**

### Projet dans un sous-dossier

Si votre projet Maven est dans un sous-dossier (ex : `POV-JAVA`), modifier le stage Build dans le Jenkinsfile :

```groovy
stage('Build') {
    steps {
        script {
            dir('POV-JAVA') {
                sh 'mvn clean install'
            }
        }
    }
}
```

### Port déjà utilisé

Si le port 8585 est déjà utilisé, modifier la variable `HOST_PORT` dans le Jenkinsfile ou arrêter le conteneur existant :

```bash
docker rm -f test-pos
```

## 📝 Structure du projet

```
tp30/
├── docker-compose.yml      # Configuration Docker Compose pour Jenkins
├── Jenkinsfile             # Pipeline CI/CD Jenkins
├── Dockerfile              # Image Docker pour l'application Spring Boot
├── README.md               # Ce fichier
└── [votre-projet-spring-boot]/
    ├── pom.xml
    └── src/
```

## 🔐 Sécurité

- ⚠️ Ne jamais publier votre authtoken ngrok dans un dépôt public
- ⚠️ Utiliser des credentials Jenkins pour les accès sensibles
- ⚠️ En production, utiliser HTTPS et authentification appropriée

## 📚 Ressources

- [Documentation Jenkins](https://www.jenkins.io/doc/)
- [Documentation Docker](https://docs.docker.com/)
- [Documentation ngrok](https://ngrok.com/docs)
- [Documentation Spring Boot](https://spring.io/projects/spring-boot)

## 📄 Licence

Ce projet est un exemple éducatif pour l'apprentissage du CI/CD.


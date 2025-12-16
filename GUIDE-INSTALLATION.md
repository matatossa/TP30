# Guide d'Installation Détaillé - TP CI/CD

Ce guide vous accompagne étape par étape pour mettre en place le pipeline CI/CD.

## 📋 Checklist de préparation

- [ ] Docker Desktop installé et démarré
- [ ] Compte GitHub créé
- [ ] Compte ngrok créé
- [ ] Git installé

## 🚀 Étape 1 : Démarrer Jenkins

### Option A : Utiliser le script Windows

```bash
start-jenkins.bat
```

### Option B : Commande manuelle

```bash
docker-compose up -d
```

### Vérification

1. Ouvrir `http://localhost:8080` dans votre navigateur
2. Récupérer le mot de passe initial :
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Coller le mot de passe dans l'interface Jenkins

## 🔧 Étape 2 : Configuration initiale de Jenkins

1. **Installation des plugins recommandés**
   - Cliquer sur "Install suggested plugins"
   - Attendre la fin de l'installation

2. **Création du compte administrateur**
   - Remplir le formulaire
   - Noter les identifiants

3. **Configuration de l'URL Jenkins**
   - Laisser par défaut (`http://localhost:8080`)
   - Cliquer sur "Save and Finish"

## ⚙️ Étape 3 : Configuration de Maven

1. **Accéder à la configuration des outils**
   - Menu : **Manage Jenkins** → **Tools**

2. **Ajouter Maven**
   - Section **Maven installations**
   - Cliquer sur **Add Maven**
   - Configuration :
     - **Name** : `maven`
     - **Install automatically** : ✓
     - **Version** : `3.9.6` (ou dernière version)
   - Cliquer sur **Save**

## 🔌 Étape 4 : Installation des plugins nécessaires

1. **Manage Jenkins** → **Plugins** → **Available plugins**

2. **Rechercher et installer** :
   - `Docker Pipeline`
   - `GitHub Integration`
   - `GitHub plugin`
   - `Pipeline: GitHub`

3. **Redémarrer Jenkins** si demandé

## 📦 Étape 5 : Créer le job Pipeline

### 5.1 Créer un nouveau job

1. **Dashboard** → **New Item**
2. Nom : `my-project` (ou votre choix)
3. Type : **Pipeline**
4. Cliquer sur **OK**

### 5.2 Configurer le job

#### Section "General"

- **Description** : "CI/CD Spring Boot + Docker"
- **GitHub project** : ✓
  - **Project url** : `https://github.com/votre-username/votre-repo`

#### Section "Build Triggers"

- **GitHub hook trigger for GITScm polling** : ✓

#### Section "Pipeline"

- **Definition** : `Pipeline script from SCM`
- **SCM** : `Git`
- **Repository URL** : `https://github.com/votre-username/votre-repo.git`
- **Credentials** : Aucun (pour dépôt public) ou ajouter credentials pour dépôt privé
- **Branch** : `*/main` (ou `*/master` selon votre dépôt GitHub)
- **Script Path** : `Jenkinsfile`

#### Enregistrer

Cliquer sur **Save**

## 🌐 Étape 6 : Configuration de ngrok

### 6.1 Télécharger ngrok

1. Aller sur https://ngrok.com/download
2. Télécharger la version Windows
3. Extraire `ngrok.exe` dans un dossier (ex : `C:\ngrok`)

### 6.2 Ajouter ngrok au PATH (optionnel)

1. Ouvrir **Variables d'environnement** Windows
2. **Variables système** → **Path** → **Modifier**
3. Ajouter `C:\ngrok` (ou le chemin où se trouve ngrok.exe)
4. **OK** pour valider

### 6.3 Configurer l'authtoken

1. Créer un compte sur https://ngrok.com (si pas déjà fait)
2. Se connecter au dashboard
3. Récupérer votre **authtoken**
4. Dans un terminal PowerShell ou CMD :
   ```bash
   ngrok config add-authtoken VOTRE_AUTHTOKEN_ICI
   ```

### 6.4 Démarrer le tunnel

#### Option A : Utiliser le script

```bash
start-ngrok.bat
```

#### Option B : Commande manuelle

```bash
ngrok http 8080
```

### 6.5 Noter l'URL publique

Ngrok affichera une URL HTTPS du type :
```
Forwarding  https://1f36-196-64-173-133.ngrok-free.app -> http://localhost:8080
```

**⚠️ IMPORTANT** : Copier cette URL, vous en aurez besoin pour le webhook GitHub.

## 🔗 Étape 7 : Configurer le webhook GitHub

### 7.1 Préparer l'URL du webhook

L'URL du webhook doit être :
```
https://VOTRE-URL-NGROK/github-webhook/
```

Exemple :
```
https://1f36-196-64-173-133.ngrok-free.app/github-webhook/
```

### 7.2 Créer le webhook dans GitHub

1. Ouvrir votre dépôt GitHub
2. Aller dans **Settings** → **Webhooks**
3. Cliquer sur **Add webhook**
4. Remplir le formulaire :
   - **Payload URL** : `https://VOTRE-URL-NGROK/github-webhook/`
   - **Content type** : `application/json`
   - **Secret** : Laisser vide (ou ajouter un secret pour plus de sécurité)
   - **Which events would you like to trigger this webhook?**
     - Sélectionner **Just the push event**
   - **Active** : ✓ (coché)
5. Cliquer sur **Add webhook**

### 7.3 Vérifier le webhook

GitHub devrait afficher une coche verte si le webhook fonctionne.

## ✅ Étape 8 : Test du pipeline

### Test manuel

1. Dans Jenkins, ouvrir le job `my-project`
2. Cliquer sur **Build Now**
3. Observer l'exécution dans la **Stage View**
4. Vérifier que toutes les étapes passent au vert

### Test automatique (via webhook)

1. Faire un changement dans votre code :
   ```bash
   git add .
   git commit -m "Test CI/CD pipeline"
   git push origin main
   ```
2. Le pipeline devrait se déclencher automatiquement dans Jenkins
3. Vérifier l'exécution dans Jenkins

### Vérifier l'application déployée

Une fois le pipeline terminé, l'application devrait être accessible sur :
```
http://localhost:8585/api/health
```

## 🔍 Dépannage

### Jenkins ne démarre pas

```bash
# Vérifier les logs
docker-compose logs jenkins

# Redémarrer
docker-compose restart jenkins
```

### Le webhook ne se déclenche pas

1. Vérifier que ngrok est toujours actif (fenêtre ouverte)
2. Vérifier l'URL du webhook dans GitHub
3. Tester manuellement avec "Build Now" dans Jenkins
4. Vérifier les logs dans **Manage Jenkins** → **System Log**

### Erreur "Docker command not found" dans Jenkins

Vérifier que Docker socket est bien monté :
```bash
docker exec jenkins docker ps
```

Si cela ne fonctionne pas, vérifier le `docker-compose.yml` et s'assurer que :
- `/var/run/docker.sock` est monté
- `/usr/bin/docker` est monté (si nécessaire)

### Port 8585 déjà utilisé

Arrêter le conteneur existant :
```bash
docker rm -f test-pos
```

Ou modifier le port dans le Jenkinsfile (variable `HOST_PORT`).

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

## 📝 Notes importantes

- **ngrok URL change** : Avec le plan gratuit, l'URL ngrok change à chaque redémarrage. Il faut mettre à jour le webhook GitHub.
- **Sécurité** : Ne jamais publier votre authtoken ngrok dans un dépôt public.
- **Données Jenkins** : Les données Jenkins sont conservées dans le volume Docker `jenkins_home`. Pour tout réinitialiser : `docker-compose down -v`

## 🎓 Prochaines étapes

Une fois le pipeline fonctionnel, vous pouvez :
- Ajouter des étapes de test supplémentaires
- Configurer des notifications (email, Slack, etc.)
- Ajouter des étapes de déploiement vers d'autres environnements
- Configurer des branches différentes (dev, staging, production)


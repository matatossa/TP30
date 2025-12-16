# 🔧 Guide de Dépannage

## Erreur : "couldn't find remote ref refs/heads/main" ou "refs/heads/master"

### Problème
Jenkins essaie de récupérer une branche qui n'existe pas encore sur GitHub.

### Causes possibles

1. **Le dépôt GitHub est vide** (le plus fréquent)
   - **Solution** : Voir `INITIALISATION-GIT.md` pour pousser le code sur GitHub d'abord

2. **La branche configurée dans Jenkins ne correspond pas à votre dépôt**
   - **Solution** : Vérifier la branche par défaut de votre dépôt GitHub et mettre à jour Jenkins

### Solution rapide

Si votre dépôt GitHub est vide :
```bash
# Initialiser Git
git init
git add .
git commit -m "Initial commit"

# Créer un dépôt sur GitHub, puis :
git remote add origin https://github.com/VOTRE-USERNAME/tp30.git
git branch -M main
git push -u origin main
```

Voir `INITIALISATION-GIT.md` pour les détails complets.

---

## Erreur : "couldn't find remote ref refs/heads/master" (ancienne version)

### Problème
Jenkins essaie de récupérer la branche `master` mais votre dépôt GitHub utilise la branche `main` (ou une autre branche).

### Solution

#### Option 1 : Modifier la configuration du job Jenkins (Recommandé)

1. Dans Jenkins, ouvrir votre job (ex : `my-project`)
2. Cliquer sur **Configure**
3. Aller dans la section **Pipeline**
4. Dans le champ **Branch Specifier**, remplacer :
   - `*/master` par `*/main`
   - Ou utiliser `*/main` ou `*/master` selon votre dépôt
5. Cliquer sur **Save**

#### Option 2 : Vérifier la branche par défaut de votre dépôt GitHub

1. Aller sur votre dépôt GitHub
2. Vérifier quelle est la branche par défaut dans **Settings** → **Branches**
3. Utiliser cette branche dans la configuration Jenkins

#### Option 3 : Utiliser une branche spécifique

Si vous voulez utiliser une branche spécifique, dans la configuration Jenkins :
- **Branch Specifier** : `*/nom-de-votre-branche`
- Exemples :
  - `*/main` pour la branche main
  - `*/develop` pour la branche develop
  - `*/master` pour la branche master

### Vérification

Après modification, tester le pipeline :
1. Cliquer sur **Build Now**
2. Vérifier que l'étape "Git Clone" passe au vert

---

## Autres erreurs courantes

### Erreur : "Docker command not found"

**Problème** : Jenkins ne peut pas exécuter Docker.

**Solution** :
```bash
# Vérifier que Docker fonctionne dans Jenkins
docker exec jenkins docker ps

# Si cela ne fonctionne pas, vérifier docker-compose.yml
# Le socket Docker doit être monté : /var/run/docker.sock
```

### Erreur : "Port already in use"

**Problème** : Le port 8585 est déjà utilisé.

**Solution** :
```bash
# Arrêter le conteneur existant
docker rm -f test-pos

# Ou modifier le port dans le Jenkinsfile (variable HOST_PORT)
```

### Erreur : "Maven not found"

**Problème** : Maven n'est pas configuré dans Jenkins.

**Solution** :
1. **Manage Jenkins** → **Tools**
2. Ajouter Maven avec installation automatique
3. Vérifier que le nom correspond à celui utilisé dans le pipeline

### Erreur : Webhook ne se déclenche pas

**Problème** : Le webhook GitHub ne déclenche pas le pipeline.

**Solutions** :
1. Vérifier que ngrok est toujours actif
2. Vérifier l'URL du webhook dans GitHub (doit être `https://VOTRE-URL-NGROK/github-webhook/`)
3. Vérifier les logs dans **Manage Jenkins** → **System Log**
4. Tester manuellement avec **Build Now**

### Erreur : "Project is in subdirectory"

**Problème** : Votre projet Maven est dans un sous-dossier.

**Solution** : Modifier le stage Build dans le Jenkinsfile :

```groovy
stage('Build') {
    steps {
        script {
            dir('POV-JAVA') {  // Remplacer par votre sous-dossier
                sh 'mvn clean install'
            }
        }
    }
}
```

---

## Commandes utiles

### Vérifier les logs Jenkins
```bash
docker-compose logs -f jenkins
```

### Redémarrer Jenkins
```bash
docker-compose restart jenkins
```

### Vérifier les conteneurs Docker
```bash
docker ps -a
```

### Nettoyer les conteneurs arrêtés
```bash
docker container prune
```

### Voir les images Docker
```bash
docker images
```

### Tester l'application déployée
```bash
curl http://localhost:8585/api/health
```

---

## Support

Si le problème persiste :
1. Vérifier les logs Jenkins (Console Output du build)
2. Vérifier les logs Docker : `docker-compose logs jenkins`
3. Vérifier la configuration du job dans Jenkins
4. Vérifier que tous les prérequis sont installés


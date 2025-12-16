# 📝 Notes Importantes

## ⚠️ Correction nécessaire dans pom.xml

Le fichier `pom.xml` contient une balise `<n>` qui doit être corrigée en `<name>`.

**Ligne 18** : Remplacer `<n>POS Application</n>` par `<name>POS Application</name>`

### Correction automatique

Exécuter le script PowerShell :
```powershell
.\fix-pom.xml.ps1
```

### Correction manuelle

Ouvrir `pom.xml` et remplacer :
- `<n>` par `<name>`
- `</n>` par `</name>`

## 🔧 Configuration Jenkins avec Docker

### Accès Docker depuis Jenkins

Le `docker-compose.yml` configure Jenkins pour accéder à Docker via le socket Docker de l'hôte. Cela permet à Jenkins d'exécuter des commandes Docker directement.

### Vérification

Pour vérifier que Docker fonctionne dans Jenkins :
```bash
docker exec jenkins docker ps
```

## 🌐 ngrok - URL changeante

**Important** : Avec le plan gratuit ngrok, l'URL publique change à chaque redémarrage de ngrok.

**Solution** : 
1. Noter la nouvelle URL à chaque démarrage
2. Mettre à jour le webhook GitHub avec la nouvelle URL

## 📦 Structure du projet

Si votre projet Maven est dans un sous-dossier (ex : `POV-JAVA`), modifier le `Jenkinsfile` :

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

## 🐛 Dépannage courant

### Port déjà utilisé
```bash
docker rm -f test-pos
```

### Jenkins ne démarre pas
```bash
docker-compose logs jenkins
docker-compose restart jenkins
```

### Webhook ne fonctionne pas
1. Vérifier que ngrok est actif
2. Vérifier l'URL dans GitHub
3. Tester manuellement avec "Build Now"


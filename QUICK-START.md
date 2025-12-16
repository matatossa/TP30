# 🚀 Guide de Démarrage Rapide

## ⚠️ Important : Pousser le code sur GitHub d'abord !

**Avant de configurer Jenkins**, assurez-vous que votre code est sur GitHub :
- Si votre dépôt GitHub est vide, voir `INITIALISATION-GIT.md`
- Exécuter `init-git.bat` pour initialiser Git localement

## Démarrage en 5 minutes

### 1. Démarrer Jenkins
```bash
start-jenkins.bat
```
Ou manuellement :
```bash
docker-compose up -d
```

### 2. Accéder à Jenkins
Ouvrir : http://localhost:8080

Mot de passe initial :
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 3. Configurer Maven dans Jenkins
- **Manage Jenkins** → **Tools** → **Maven installations**
- Ajouter Maven avec installation automatique (version 3.9.6)

### 4. Créer le job Pipeline
- **New Item** → Nom : `my-project` → **Pipeline**
- **GitHub project** : URL de votre repo
- **Build Triggers** : Cocher "GitHub hook trigger"
- **Pipeline** : `Pipeline script from SCM`
  - Repository URL : Votre repo GitHub
  - **Branch Specifier** : `*/main` (ou `*/master` selon votre dépôt)
  - Script Path : `Jenkinsfile`

### 5. Configurer ngrok
```bash
# Configurer l'authtoken (une seule fois)
ngrok config add-authtoken VOTRE_TOKEN

# Démarrer le tunnel
start-ngrok.bat
# Ou : ngrok http 8080
```

### 6. Configurer le webhook GitHub
- **Settings** → **Webhooks** → **Add webhook**
- URL : `https://VOTRE-URL-NGROK/github-webhook/`
- Events : "Just the push event"

### 7. Tester
```bash
git add .
git commit -m "Test CI/CD"
git push origin main
```

Le pipeline se déclenchera automatiquement ! 🎉

## 📚 Documentation complète
Voir `README.md` et `GUIDE-INSTALLATION.md` pour plus de détails.


# ✅ Appliquer la correction Maven

## Modifications effectuées

1. ✅ `docker-compose.yml` : Installation automatique de Maven dans le conteneur Jenkins
2. ✅ `Jenkinsfile` : Simplifié pour utiliser Maven directement

## 📋 Étapes à suivre

### 1. Pousser les modifications sur GitHub

```bash
git add docker-compose.yml Jenkinsfile
git commit -m "Fix: Install Maven directly in Jenkins container"
git push origin main
```

### 2. Redémarrer Jenkins avec la nouvelle configuration

```bash
# Arrêter Jenkins
docker-compose down

# Redémarrer avec la nouvelle configuration (Maven sera installé automatiquement)
docker-compose up -d

# Attendre quelques secondes que Jenkins démarre
# Vérifier les logs pour voir l'installation de Maven
docker-compose logs -f jenkins
```

Vous devriez voir dans les logs :
```
Setting up maven...
```

### 3. Relancer le pipeline dans Jenkins

1. Aller sur Jenkins : http://localhost:8080
2. Ouvrir votre job `tp30` (ou le nom de votre job)
3. Cliquer sur **Build Now**
4. Le pipeline devrait maintenant trouver Maven ! ✅

## 🔍 Vérification

Si vous voulez vérifier que Maven est installé dans le conteneur :

```bash
docker exec jenkins mvn -version
```

Vous devriez voir la version de Maven affichée.

## ⚠️ Note

La première fois que Jenkins démarre avec cette configuration, l'installation de Maven peut prendre 1-2 minutes. C'est normal !

## 🐛 Si ça ne fonctionne toujours pas

Vérifier les logs Jenkins :
```bash
docker-compose logs jenkins | grep -i maven
```

Ou voir tous les logs :
```bash
docker-compose logs jenkins
```


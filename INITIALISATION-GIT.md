# 📦 Initialisation Git et Push vers GitHub

## ⚠️ Problème

L'erreur `couldn't find remote ref refs/heads/main` signifie que **votre dépôt GitHub est vide** ou que la branche n'existe pas encore sur GitHub.

**Solution** : Il faut initialiser Git localement et pousser le code sur GitHub AVANT de configurer Jenkins.

## 🚀 Étapes complètes

### Étape 1 : Initialiser le dépôt Git local

```bash
# Initialiser Git dans le dossier du projet
git init

# Ajouter tous les fichiers
git add .

# Faire le premier commit
git commit -m "Initial commit - Setup CI/CD pipeline"
```

### Étape 2 : Créer un dépôt sur GitHub

1. Aller sur https://github.com
2. Cliquer sur le bouton **+** (en haut à droite) → **New repository**
3. Remplir :
   - **Repository name** : `tp30` (ou le nom de votre choix)
   - **Description** : "TP CI/CD avec Jenkins, Docker et ngrok"
   - **Visibility** : Public ou Private (selon votre choix)
   - **NE PAS** cocher "Initialize this repository with a README" (vous avez déjà un README)
4. Cliquer sur **Create repository**

### Étape 3 : Connecter le dépôt local à GitHub

GitHub vous donnera des instructions après la création. Utilisez ces commandes :

```bash
# Ajouter le remote GitHub (remplacer VOTRE-USERNAME par votre nom d'utilisateur GitHub)
git remote add origin https://github.com/VOTRE-USERNAME/tp30.git

# Renommer la branche en main (si nécessaire)
git branch -M main

# Pousser le code sur GitHub
git push -u origin main
```

**Note** : Si vous utilisez HTTPS, GitHub vous demandera vos identifiants. Si vous utilisez SSH, utilisez :
```bash
git remote add origin git@github.com:VOTRE-USERNAME/tp30.git
```

### Étape 4 : Vérifier sur GitHub

1. Rafraîchir la page de votre dépôt GitHub
2. Vous devriez voir tous vos fichiers (README.md, Jenkinsfile, pom.xml, etc.)
3. Vérifier que la branche `main` existe bien

### Étape 5 : Configurer Jenkins

Maintenant que le code est sur GitHub, vous pouvez :

1. Dans Jenkins, ouvrir votre job
2. **Configure** → Section **Pipeline**
3. Vérifier que :
   - **Repository URL** : `https://github.com/VOTRE-USERNAME/tp30.git`
   - **Branch Specifier** : `*/main`
4. **Save**
5. Cliquer sur **Build Now**

## 🔐 Authentification GitHub

### Option 1 : HTTPS (Simple)

GitHub vous demandera votre nom d'utilisateur et un **Personal Access Token** (pas votre mot de passe).

Pour créer un token :
1. GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. **Generate new token**
3. Cocher `repo` (accès complet aux dépôts)
4. Copier le token et l'utiliser comme mot de passe lors du `git push`

### Option 2 : SSH (Recommandé pour la production)

1. Générer une clé SSH :
   ```bash
   ssh-keygen -t ed25519 -C "votre-email@example.com"
   ```

2. Copier la clé publique :
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. Sur GitHub : **Settings** → **SSH and GPG keys** → **New SSH key**
4. Coller la clé publique
5. Utiliser l'URL SSH pour le remote :
   ```bash
   git remote set-url origin git@github.com:VOTRE-USERNAME/tp30.git
   ```

## 📝 Script rapide (Windows)

Créez un fichier `init-git.bat` avec ce contenu (à adapter avec votre URL GitHub) :

```batch
@echo off
echo Initialisation du depot Git...
git init
git add .
git commit -m "Initial commit - Setup CI/CD pipeline"
echo.
echo Ajout du remote GitHub...
echo REMPLACER VOTRE-USERNAME par votre nom d'utilisateur GitHub
git remote add origin https://github.com/VOTRE-USERNAME/tp30.git
git branch -M main
echo.
echo Pousser vers GitHub...
git push -u origin main
echo.
echo Termine! Verifiez sur GitHub que tous les fichiers sont bien presents.
pause
```

## ✅ Checklist

- [ ] Dépôt Git initialisé localement (`git init`)
- [ ] Fichiers ajoutés et commités (`git add .` et `git commit`)
- [ ] Dépôt GitHub créé
- [ ] Remote GitHub ajouté (`git remote add origin`)
- [ ] Code poussé sur GitHub (`git push`)
- [ ] Vérification sur GitHub que les fichiers sont présents
- [ ] Configuration Jenkins mise à jour avec la bonne URL et branche

## 🐛 Dépannage

### Erreur : "remote origin already exists"

```bash
# Supprimer l'ancien remote
git remote remove origin

# Ajouter le nouveau
git remote add origin https://github.com/VOTRE-USERNAME/tp30.git
```

### Erreur : "failed to push some refs"

Votre dépôt GitHub a peut-être un README initial. Faire un pull d'abord :

```bash
git pull origin main --allow-unrelated-histories
git push -u origin main
```

### Erreur d'authentification

- Vérifier que vous utilisez un **Personal Access Token** (pas votre mot de passe)
- Ou configurer SSH comme expliqué ci-dessus

## 📚 Prochaines étapes

Une fois le code sur GitHub :
1. Configurer Jenkins avec la bonne URL et branche
2. Configurer ngrok
3. Configurer le webhook GitHub
4. Tester le pipeline !

Voir `QUICK-START.md` pour la suite.


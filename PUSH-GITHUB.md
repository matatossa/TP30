# 🔐 Push vers GitHub - Authentification

## ✅ État actuel

- ✅ Git initialisé
- ✅ Fichiers ajoutés et commités (23 fichiers)
- ⏳ Push vers GitHub en attente (authentification requise)

## 🔑 Options d'authentification

### Option 1 : Personal Access Token (HTTPS) - Recommandé

GitHub ne permet plus d'utiliser votre mot de passe. Vous devez créer un **Personal Access Token**.

#### Étapes :

1. **Créer un token sur GitHub** :
   - Aller sur https://github.com/settings/tokens
   - Cliquer sur **Generate new token** → **Generate new token (classic)**
   - Donner un nom : "TP30 Local"
   - Cocher la case **repo** (accès complet aux dépôts)
   - Cliquer sur **Generate token**
   - **⚠️ IMPORTANT** : Copier le token immédiatement (vous ne pourrez plus le voir après)

2. **Pousser avec le token** :
   ```bash
   git push -u origin main
   ```
   
   Quand GitHub demande :
   - **Username** : `matatossa`
   - **Password** : Collez votre **Personal Access Token** (pas votre mot de passe GitHub)

### Option 2 : GitHub CLI (Plus simple)

Installer GitHub CLI et s'authentifier :

```bash
# Installer GitHub CLI depuis https://cli.github.com/
# Puis :
gh auth login
git push -u origin main
```

### Option 3 : SSH (Pour usage répété)

1. **Générer une clé SSH** :
   ```bash
   ssh-keygen -t ed25519 -C "votre-email@example.com"
   ```

2. **Copier la clé publique** :
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Ajouter sur GitHub** :
   - Aller sur https://github.com/settings/keys
   - Cliquer sur **New SSH key**
   - Coller la clé publique

4. **Changer l'URL du remote** :
   ```bash
   git remote set-url origin git@github.com:matatossa/TP30.git
   git push -u origin main
   ```

## 🚀 Commande rapide

Une fois votre token créé, exécutez simplement :

```bash
git push -u origin main
```

Et utilisez votre token comme mot de passe.

## ✅ Vérification

Après le push réussi :
1. Aller sur https://github.com/matatossa/TP30
2. Vérifier que tous les fichiers sont présents
3. Vérifier que la branche `main` existe

Ensuite, vous pourrez configurer Jenkins avec cette URL : `https://github.com/matatossa/TP30.git`


# 🔧 Correction : Erreur "couldn't find remote ref refs/heads/master"

## ⚠️ Problème

Vous avez cette erreur lors de l'exécution du pipeline :
```
fatal: couldn't find remote ref refs/heads/master
```

**Cause** : Jenkins essaie de récupérer la branche `master` mais votre dépôt GitHub utilise la branche `main` (ou une autre branche).

## ✅ Solution Rapide

### Étape 1 : Identifier votre branche GitHub

1. Aller sur votre dépôt GitHub
2. Regarder en haut de la page : vous verrez la branche actuelle (probablement `main`)

### Étape 2 : Modifier la configuration Jenkins

1. **Dans Jenkins**, ouvrir votre job (ex : `my-project`)
2. Cliquer sur **Configure** (à gauche)
3. Descendre jusqu'à la section **Pipeline**
4. Trouver le champ **Branch Specifier** (ou **Branches to build**)
5. **Remplacer** `*/master` par `*/main`
   - Si votre branche s'appelle autrement, utiliser `*/nom-de-votre-branche`
6. Cliquer sur **Save** en bas de la page

### Étape 3 : Tester

1. Cliquer sur **Build Now**
2. Vérifier que l'étape "Git Clone" passe au vert ✓

## 📸 Aide visuelle

### Dans Jenkins - Section Pipeline

```
Pipeline
├── Definition: Pipeline script from SCM
├── SCM: Git
├── Repository URL: https://github.com/votre-username/votre-repo.git
├── Branch Specifier: */main  ← MODIFIER ICI
└── Script Path: Jenkinsfile
```

### Exemples de Branch Specifier

- `*/main` → Pour la branche main
- `*/master` → Pour la branche master
- `*/develop` → Pour la branche develop
- `*/feature/*` → Pour toutes les branches commençant par feature/

## 🔍 Vérification

Pour vérifier quelle branche votre dépôt utilise :

```bash
# Dans votre dépôt local
git branch -r

# Ou sur GitHub
# Aller dans Settings → Branches → Default branch
```

## 💡 Astuce

Si vous avez plusieurs branches et voulez que Jenkins les détecte toutes automatiquement, vous pouvez utiliser :
- `*/main` pour la branche main uniquement
- `**` pour toutes les branches (non recommandé pour la production)

## 📚 Documentation complète

Voir `DEPANNAGE.md` pour plus d'informations sur les erreurs courantes.


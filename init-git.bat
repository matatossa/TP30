@echo off
echo ========================================
echo   Initialisation du depot Git
echo ========================================
echo.

REM Verifier si Git est installe
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Git n'est pas installe ou n'est pas dans le PATH.
    echo [INFO] Installez Git depuis https://git-scm.com/download/win
    pause
    exit /b 1
)

echo [INFO] Initialisation du depot Git...
git init

echo.
echo [INFO] Ajout des fichiers...
git add .

echo.
echo [INFO] Creation du premier commit...
git commit -m "Initial commit - Setup CI/CD pipeline"

echo.
echo ========================================
echo   Configuration du remote GitHub
echo ========================================
echo.
echo [INFO] Vous devez maintenant :
echo 1. Creer un depot sur GitHub (https://github.com/new)
echo 2. Copier l'URL du depot (ex: https://github.com/VOTRE-USERNAME/tp30.git)
echo 3. Executer les commandes suivantes :
echo.
echo    git remote add origin https://github.com/VOTRE-USERNAME/tp30.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo [INFO] Pour plus de details, voir INITIALISATION-GIT.md
echo.
pause


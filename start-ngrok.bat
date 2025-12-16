@echo off
echo ========================================
echo   Demarrage de ngrok pour Jenkins
echo ========================================
echo.

REM Verifier si ngrok est dans le PATH ou dans le dossier courant
where ngrok >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] ngrok n'est pas trouve dans le PATH.
    echo [INFO] Assurez-vous que ngrok.exe est dans le PATH ou dans ce dossier.
    echo [INFO] Ou modifiez ce script pour pointer vers ngrok.exe
    pause
    exit /b 1
)

echo [INFO] Demarrage du tunnel ngrok sur le port 8080...
echo [INFO] L'URL publique sera affichee ci-dessous.
echo [INFO] Utilisez cette URL pour configurer le webhook GitHub.
echo.
echo ========================================
ngrok http 8080


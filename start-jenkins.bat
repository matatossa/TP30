@echo off
echo ========================================
echo   Demarrage de Jenkins avec Docker
echo ========================================
echo.

REM Verifier si Docker est en cours d'execution
docker ps >nul 2>&1
if errorlevel 1 (
    echo [ERREUR] Docker n'est pas demarre. Veuillez demarrer Docker Desktop.
    pause
    exit /b 1
)

echo [INFO] Demarrage de Jenkins...
docker-compose up -d

echo.
echo [INFO] Attente du demarrage de Jenkins (30 secondes)...
timeout /t 30 /nobreak >nul

echo.
echo ========================================
echo   Jenkins est accessible sur:
echo   http://localhost:8080
echo ========================================
echo.
echo [INFO] Mot de passe initial:
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
echo.
echo [INFO] Pour voir les logs: docker-compose logs -f jenkins
echo [INFO] Pour arreter: docker-compose down
echo.
pause


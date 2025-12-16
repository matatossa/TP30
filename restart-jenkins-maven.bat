@echo off
echo ========================================
echo   Redemarrage de Jenkins avec Maven
echo ========================================
echo.

echo [INFO] Arret de Jenkins...
docker-compose down

echo.
echo [INFO] Demarrage de Jenkins avec installation de Maven...
echo [INFO] Cela peut prendre 1-2 minutes la premiere fois...
docker-compose up -d

echo.
echo [INFO] Attente du demarrage de Jenkins (30 secondes)...
timeout /t 30 /nobreak >nul

echo.
echo ========================================
echo   Jenkins redemarre avec Maven installe
echo ========================================
echo.
echo [INFO] Pour verifier les logs: docker-compose logs -f jenkins
echo [INFO] Pour verifier Maven: docker exec jenkins mvn -version
echo.
echo [INFO] Vous pouvez maintenant relancer le pipeline dans Jenkins!
echo.
pause


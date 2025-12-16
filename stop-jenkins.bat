@echo off
echo ========================================
echo   Arret de Jenkins
echo ========================================
echo.

echo [INFO] Arret des conteneurs...
docker-compose down

echo.
echo [INFO] Jenkins a ete arrete.
echo [INFO] Les donnees sont conservees dans le volume Docker.
echo.
pause


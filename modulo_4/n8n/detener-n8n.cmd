@echo off
setlocal
cd /d "%~dp0"

echo Deteniendo n8n sin borrar sus datos...
docker compose stop
if errorlevel 1 (
  echo No se pudo detener n8n. Confirme que Docker Desktop este iniciado.
  pause
  exit /b 1
)

echo n8n fue detenido. El volumen clase_n8n_data se conserva.
pause
endlocal

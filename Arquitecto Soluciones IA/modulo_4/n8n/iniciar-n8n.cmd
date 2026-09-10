@echo off
setlocal
cd /d "%~dp0"

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker no esta disponible.
  echo Abra Docker Desktop, espere a que inicie y vuelva a intentar.
  pause
  exit /b 1
)

echo Iniciando n8n...
docker compose up -d
if errorlevel 1 (
  echo No se pudo iniciar n8n. Revise los mensajes anteriores.
  pause
  exit /b 1
)

docker compose ps
start "" "http://127.0.0.1:5678"
echo.
echo n8n esta disponible en http://127.0.0.1:5678
echo Puede cerrar esta ventana. Docker Desktop debe seguir iniciado.
pause
endlocal

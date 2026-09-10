# Entorno local de n8n para el módulo 4

Esta carpeta inicia n8n `2.35.7` con Docker Compose. Utiliza la imagen oficial, guarda los datos en un volumen persistente y publica el editor solamente en la computadora local.


## Prerrequisito

Docker Desktop debe estar instalado, iniciado y probado antes de la clase.

En Símbolo del sistema:

```console
docker --version
docker compose version
docker info
```

Instalar Docker Desktop durante el encuentro puede requerir permisos administrativos y un reinicio.

## Primer inicio con Internet

Abrir una terminal en esta carpeta y ejecutar:

```console
docker compose pull
docker compose up -d
docker compose ps
```

Luego abrir:

```text
http://127.0.0.1:5678
```

En Windows también se puede hacer doble clic en `iniciar-n8n.cmd`.

La primera vez, completar la creación del usuario propietario. Cada equipo debe usar una contraseña individual.

## Operación habitual

Iniciar:

```console
docker compose up -d
```

Ver estado:

```console
docker compose ps
```

Ver los últimos mensajes:

```console
docker compose logs --tail 50 n8n
```

Detener sin borrar datos:

```console
docker compose stop
```

En Windows se pueden usar `iniciar-n8n.cmd` y `detener-n8n.cmd`. Los scripts siempre trabajan desde esta carpeta y no modifican políticas de PowerShell.

## Persistencia

La configuración guarda `/home/node/.n8n` en el volumen nombrado `clase_n8n_data`. Allí quedan la cuenta, las configuraciones y los workflows.

```text
Apagar/Borrar:
No usar estos comandos en el curso, ambos pueden borrar los datos persistentes. 

docker compose down -v
docker volume rm clase_n8n_data
```

>Detener con `docker compose stop` es suficiente.

## Problemas frecuentes

- Si `docker info` no conecta, abrir Docker Desktop y esperar a que el motor esté listo.
- Si el puerto 5678 está ocupado, comprobar que no exista otra instancia de n8n. No finalizar procesos desconocidos.
- Si el contenedor se detiene, ejecutar `docker compose logs --tail 50 n8n`.
- Si la página no abre, comprobar que se use `http://127.0.0.1:5678`, sin `https`.
- Si falla la descarga, usar el plan offline o consultar las restricciones de red institucionales.

## Configuración incluida

- Imagen: `docker.n8n.io/n8nio/n8n:2.35.7`.
- Puerto: `127.0.0.1:5678` hacia el puerto `5678` del contenedor.
- Zona horaria: `America/Argentina/Mendoza`.
- Volumen persistente: `clase_n8n_data`.

Referencia oficial: [instalar n8n con Docker](https://docs.n8n.io/deploy/host-n8n/install-options/install-with-docker).

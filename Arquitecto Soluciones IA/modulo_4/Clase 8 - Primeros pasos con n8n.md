# Clase 8 — Primeros pasos con n8n

**Duración:** 90 minutos  
**Nivel:** inicial, sin conocimientos previos de n8n  
**Modalidad:** instalación guiada, explicación breve, observación y construcción manual  
**Producto:** n8n funcionando localmente y un primer workflow construido desde un canvas vacío

## Idea central

Una automatización recibe datos, realiza una secuencia de tareas y entrega un resultado. En esta primera clase los estudiantes construirán cada nodo y cada campo a mano para observar cómo cambia la información paso a paso.

El caso será registrar y confirmar la inscripción de una persona a un taller:

```text
Inicio manual
  → Cargar inscripción
  → Completar registro
  → Preparar confirmación
```

No se utilizarán bifurcaciones, servicios externos ni decisiones automáticas. El foco estará en el canvas, los nodos, JSON, los items y las vistas INPUT y OUTPUT.

## Objetivos de aprendizaje

Al finalizar la clase, cada estudiante podrá:

- iniciar y detener n8n con Docker Compose sin borrar sus datos;
- comprobar que la cuenta y los workflows persisten;
- explicar qué problema resuelve una automatización sencilla;
- reconocer un workflow, un nodo, una conexión y un trigger;
- ejecutar un workflow manualmente;
- leer y escribir un objeto JSON sencillo;
- distinguir strings, números, booleanos, `null` y arrays;
- reconocer que n8n transporta información mediante items;
- inspeccionar INPUT y OUTPUT;
- crear campos de distintos tipos con Edit Fields;
- recuperar un valor del item mediante una expresión sencilla;
- describir el contrato de datos entre nodos.

## Materiales

Dentro de la carpeta `n8n/`:

- `compose.yaml`: configuración local de n8n.
- `iniciar-n8n.cmd` y `detener-n8n.cmd`: accesos simples para Windows.
- `README.md`: guía breve de instalación, operación y plan offline.
- `Clase 8 - Contrato y ejemplos de inscripciones.json`: material documental para leer y copiar datos.

El archivo de ejemplos es una referencia documental. En esta clase el workflow se crea manualmente desde un canvas vacío.

## Preparación del entorno n8n

Docker Desktop es un **prerrequisito técnico**. Debe estar instalado e iniciado.

Descarga: https://www.docker.com/products/docker-desktop/

Antes de la clase:

1. Confirmar que Docker Desktop funciona en cada computadora.
2. Comprobar con estos comandos (en la terminal o powershell) si esta funcionando: `docker --version`, `docker compose version` y `docker info`.



## Agenda

| Tiempo | Momento | Propósito |
|---:|---|---|
| 0–20 min | Iniciar n8n con Docker Compose | Comprobar el entorno, crear el owner y verificar persistencia |
| 20–30 min | Automatización e interfaz | Reconocer problema, canvas, workflow, nodos y trigger |
| 30–48 min | JSON desde cero | Comprender la forma y los tipos de los datos |
| 48–58 min | Items y contratos | Seguir datos entre INPUT y OUTPUT |
| 58–82 min | Primer workflow | Construir manualmente los cuatro nodos lineales |
| 82–88 min | Predicción y segunda prueba | Modificar valores y anticipar la salida |
| 88–90 min | Cierre | Recuperar las ideas principales |

Si la clase debe durar 70 minutos, dejar descargada la imagen, iniciar el contenedor y crear el owner antes del encuentro. Comenzar con una comprobación de cinco minutos y conservar el resto de la secuencia.

---

## 1. Iniciar n8n con Docker Compose

### 1.1 Configuración inicial

Copiar la carpeta `n8n/` a cada computadora. Contiene la base del entorno local de n8n con Docker.

>Ubicar la carpeta en un disco con permisos de lectura y escritura. **Evitar carpetas sincronizadas** con servicios de nube, repositorios Git o recursos de red.

La carpeta `n8n/` contiene este entorno:

```text
Docker Desktop
  → compose.yaml
  → imagen oficial docker.n8n.io/n8nio/n8n:2.35.7
  → volumen persistente clase_n8n_data
  → http://127.0.0.1:5678
```

La configuración:

- fija la versión de n8n para que todo el curso use la misma interfaz;
- guarda la cuenta y los workflows en un volumen nombrado;
- enlaza el puerto solamente con `127.0.0.1`;
- configura `America/Argentina/Mendoza` como zona horaria;

### 1.2 Comprobar Docker

En Windows, abrir Docker Desktop y esperar hasta que el motor esté iniciado. Abrir después Símbolo del sistema y ejecutar:

```console
docker --version
docker compose version
docker info
```

Los primeros dos comandos deben mostrar sus versiones. `docker info` debe responder sin indicar que no puede conectarse al motor.

>En macOS o Linux se realizan las mismas comprobaciones desde una terminal.


### 1.3 Abrir la carpeta e iniciar

Ubicarse desde la terminal en la carpeta `n8n/`. 
- *En Windows se puede escribir `cd`, dejar un espacio, arrastrar la carpeta a Símbolo del sistema y presionar Enter.*

Con Internet disponible ejecutamos estos comandos para descargar la imagen y levantar el contenedor:

```console
docker compose pull
docker compose up -d
docker compose ps
```

También se puede hacer doble clic en `iniciar-n8n.cmd`.

Abrir en el navegador:

```text
http://127.0.0.1:5678
```

Usar `http`, no `https`.

### 1.4 Crear el owner

La primera vez, n8n solicita crear la cuenta propietaria u owner.

1. Completar nombre y apellido.
2. Ingresar una dirección de correo para identificar la cuenta local.
3. Crear una contraseña individual y guardarla de forma segura.
4. Completar la pantalla inicial hasta llegar al espacio de trabajo.

### 1.5 Comprobar persistencia

1. Crear un workflow vacío llamado **Prueba de persistencia**.
2. Guardarlo.
3. Volver a la terminal y ejecutar:

```console
docker compose stop
```

4. Comprobar que la página deja de responder.
5. Volver a iniciar:

```console
docker compose up -d
```

6. Recargar `http://127.0.0.1:5678`.
7. Confirmar que la cuenta y **Prueba de persistencia** siguen disponibles.

También pueden usarse `detener-n8n.cmd` e `iniciar-n8n.cmd`.

Los datos se conservan en el volumen `clase_n8n_data`. No ejecutar `docker compose down -v` ni `docker volume rm clase_n8n_data`: esos comandos pueden borrar los datos persistentes.

### 1.6 Operación cotidiana

```console
docker compose up -d
docker compose ps
docker compose logs --tail 50 n8n
docker compose stop
```

Después de `up -d` se puede cerrar la terminal porque el contenedor queda en segundo plano. Docker Desktop debe permanecer iniciado.

### 1.7 Problemas frecuentes

| Problema | Comprobación | Acción segura |
|---|---|---|
| `docker` no se reconoce | `docker --version` | Confirmar que Docker Desktop esté instalado y abrir una terminal nueva. |
| Docker no responde | `docker info` | Abrir Docker Desktop y esperar a que el motor esté listo. |
| Descarga lenta o error de red | Observar `docker compose pull` | Esperar, revisar la red o utilizar el plan offline docente. |
| Puerto 5678 ocupado | El mensaje indica que la dirección ya está en uso | Buscar otra instancia local. No finalizar procesos desconocidos. |
| El contenedor se detiene | `docker compose ps` | Revisar `docker compose logs --tail 50 n8n`. |
| El navegador no conecta | El contenedor figura iniciado | Abrir exactamente `http://127.0.0.1:5678` y revisar firewall institucional. |


---

## 2. ¿Qué vamos a automatizar? (5 min)

Presentar la situación:

> Cada vez que una persona se inscribe a un taller, alguien registra sus datos, marca el estado de la inscripción y prepara un mensaje de confirmación.

Preguntar:

- ¿Qué datos entrega la persona?
- ¿Qué tareas se repiten?
- ¿Qué resultado se espera?

Registrar las respuestas:

| Entrada | Tareas | Resultado |
|---|---|---|
| Datos de inscripción | Conservar datos, agregar estado y redactar mensaje | Confirmación estructurada |

Definición de trabajo:

> Una automatización es una secuencia de pasos que procesa datos para obtener un resultado.

### Vocabulario mínimo de la interfaz

**Canvas:** espacio en el que ubicamos y conectamos nodos.  
**Workflow:** proceso completo representado en el canvas.  
**Nodo:** un paso que recibe datos, realiza una tarea y entrega datos.  
**Conexión:** línea que indica hacia dónde viajan los datos.  
**Trigger:** nodo que inicia una ejecución.  
**Ejecución:** una corrida concreta del workflow.

En esta práctica se usa Manual Trigger. El workflow comenzará cuando seleccionemos **Execute workflow**.

Crear ahora un workflow nuevo, vacío, y nombrarlo:

```text
Clase 8 - Registro de inscripciones
```

No agregar todavía los demás nodos.

---

## 3. JSON desde cero (15 min)

JSON es un formato de texto para representar datos estructurados. El archivo documental de la clase contiene contratos y ejemplos escritos en este formato.

### 3.1 Objeto, claves y valores

```json
{
  "inscripcion_id": "INS-001",
  "nombre": "Lucía Gómez",
  "cantidad_asistentes": 1,
  "confirmada": true
}
```

Un objeto comienza con `{` y termina con `}`. Dentro hay pares de clave y valor:

```text
"nombre": "Lucía Gómez"
   clave : valor
```

Reglas visuales:

- las claves llevan comillas dobles;
- los dos puntos separan clave y valor;
- las comas separan un par del siguiente;
- el último par no lleva coma final;
- las llaves contienen el objeto.

### 3.2 Tipos de valores

**String**

```json
"modalidad": "presencial"
```

El texto lleva comillas dobles. Si más adelante se guarda una fecha en JSON, normalmente se representará como string, por ejemplo `"2026-09-15"`.

**Número**

```json
"cantidad_asistentes": 2
```

Los números no llevan comillas.

**Booleano**

```json
"confirmada": true
```

Puede ser `true` o `false`, sin comillas.

**Null**

```json
"observaciones": null
```

`null` expresa ausencia de valor. No es lo mismo que el string `"null"`.

**Array: primera aproximación**

```json
"intereses": ["automatización", "datos"]
```

Un array es una lista ordenada entre corchetes. En esta clase solo necesitamos reconocerlo.

-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-

---

## 4. Items, INPUT, OUTPUT y contrato de datos (10 min)

n8n procesa información mediante **items**. En esta clase una inscripción será un item y su contenido será un objeto JSON.

Representación conceptual:

```json
[
  {
    "json": {
      "inscripcion_id": "INS-001",
      "nombre": "Lucía Gómez"
    }
  }
]
```

Los corchetes exteriores indican una lista de items. Hoy trabajaremos con uno.

Cada nodo puede observarse así:

```text
INPUT → tarea del nodo → OUTPUT
```

- INPUT muestra los datos recibidos.
- OUTPUT muestra los datos entregados.

### Contrato de entrada

| Campo | Tipo | Obligatorio | Ejemplo |
|---|---|---:|---|
| `inscripcion_id` | string | sí | `"INS-001"` |
| `nombre` | string | sí | `"Lucía Gómez"` |
| `email` | string | sí | `"lucia@example.com"` |
| `taller` | string | sí | `"Introducción a n8n"` |
| `modalidad` | string | sí | `"presencial"` |
| `cantidad_asistentes` | number | sí | `1` |
| `confirmada` | boolean | sí | `true` |

Un contrato de datos acuerda el nombre, tipo, obligatoriedad y ejemplo de cada campo. `inscripcion_id` e `Inscripcion_ID` serían nombres diferentes; `true` y `"true"` tendrían tipos diferentes.

---

## 5. Práctica guiada: construir el workflow (25 min)

Todos los pasos se realizan manualmente en el canvas. Usar el archivo documental solo para leer o copiar valores de ejemplo.

### Paso 1 — Manual Trigger

1. En el workflow vacío, agregar **Manual Trigger**.
2. Renombrarlo **Inicio manual**.
3. Guardar.

Este nodo inicia la ejecución, pero todavía no produce los datos de la inscripción.

### Paso 2 — Cargar inscripción

1. Agregar **Edit Fields**.
2. Conectarlo desde **Inicio manual**.
3. Renombrarlo **Cargar inscripción**.
4. Crear a mano estos campos y seleccionar el tipo indicado:

| Campo | Tipo en Edit Fields | Valor fijo |
|---|---|---|
| `inscripcion_id` | String | `INS-001` |
| `nombre` | String | `Lucía Gómez` |
| `email` | String | `lucia@example.com` |
| `taller` | String | `Introducción a n8n` |
| `modalidad` | String | `presencial` |
| `cantidad_asistentes` | Number | `1` |
| `confirmada` | Boolean | `true` |

Antes de ejecutar, predecir:

- ¿Cuántos campos tendrá el OUTPUT?
- ¿Cuál será número?
- ¿Cuál será booleano?

Ejecutar el nodo y observar el OUTPUT en vista JSON.

### Paso 3 — Completar registro

1. Agregar otro **Edit Fields**.
2. Conectarlo desde **Cargar inscripción**.
3. Renombrarlo **Completar registro**.
4. Activar **Include Other Input Fields** para conservar todos los datos recibidos.
5. Agregar `estado`, tipo String, con el valor fijo `registrada`.
6. Agregar `mensaje`, tipo String.
7. Cambiar `mensaje` al modo **Expression** y escribir:

```text
=Hola {{ $json.nombre }}, tu inscripción fue registrada.
```

> `$json.nombre` recupera el valor del campo `nombre` del item actual.



Ejecutar el nodo y comparar INPUT con OUTPUT.

### Paso 4 — Preparar confirmación

1. Agregar un tercer **Edit Fields**.
2. Conectarlo desde **Completar registro**.
3. Renombrarlo **Preparar confirmación**.
4. Dejar desactivado **Include Other Input Fields** para producir solamente el contrato final.
5. Crear los campos siguientes. Cada valor se obtiene desde el item actual con una expresión.

| Campo final | Tipo | Expresión |
|---|---|---|
| `inscripcion_id` | String | `{{ $json.inscripcion_id }}` |
| `estado` | String | `{{ $json.estado }}` |
| `taller` | String | `{{ $json.taller }}` |
| `modalidad` | String | `{{ $json.modalidad }}` |
| `cantidad_asistentes` | Number | `{{ $json.cantidad_asistentes }}` |
| `confirmada` | Boolean | `{{ $json.confirmada }}` |
| `mensaje` | String | `{{ $json.mensaje }}` |

### Paso 5 — Ejecutar y observar

Antes de seleccionar **Execute workflow**, cada estudiante escribe cómo espera que se vea el JSON final.

Ejecutar el workflow completo y abrir los nodos en orden:

1. Inicio manual.
2. Cargar inscripción.
3. Completar registro.
4. Preparar confirmación.

Salida esperada:

```json
{
  "inscripcion_id": "INS-001",
  "estado": "registrada",
  "taller": "Introducción a n8n",
  "modalidad": "presencial",
  "cantidad_asistentes": 1,
  "confirmada": true,
  "mensaje": "Hola Lucía Gómez, tu inscripción fue registrada."
}
```

Preguntar en cada paso:

- ¿Cuántos items entraron y salieron?
- ¿Qué campos se conservaron?
- ¿Qué campos aparecieron?
- ¿El tipo de cada valor coincide con el contrato?


---

## 6. Cierre 

Completar oralmente:

1. Un nodo recibe ______ y entrega ______.
2. En JSON, clave y valor se separan con ______.
3. La diferencia entre `2` y `"2"` es ______.
4. `$json.nombre` permite ______.
5. INPUT y OUTPUT sirven para ______.
6. Los datos locales persisten gracias a ______.

Idea final:

> Antes de automatizar decisiones, necesitamos saber qué datos existen, qué forma tienen y qué espera recibir cada paso.



## Referencias 

- [Instalar n8n con Docker](https://docs.n8n.io/deploy/host-n8n/install-options/install-with-docker)
- [Crear y ejecutar workflows](https://docs.n8n.io/build/understand-workflows/create-and-run-workflows)
- [Trabajar con nodos](https://docs.n8n.io/build/understand-workflows/workflow-components/work-with-nodes)
- [Estructura de datos](https://docs.n8n.io/build/work-with-data/understand-n8ns-data-structure)
- [Nodo Edit Fields](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.set)

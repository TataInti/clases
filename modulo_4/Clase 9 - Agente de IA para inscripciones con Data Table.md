# Clase 9 — Construcción manual de un agente de IA en n8n
## Inscripciones a cursos con Data Table

**Duración estimada:** 90 minutos  
**Modalidad:** construcción guiada desde un canvas vacío  
**Continuidad:** Clase 8 — Primeros pasos con n8n  
**Archivo JSON de respaldo:** `n8n/Clase 9 - Inscripcion con agente y Data Table.json`

## Importante antes de comenzar

Durante la clase **no se importa el JSON**.

El JSON queda preparado como material de respaldo, pero el objetivo didáctico es construir el workflow manualmente, agregando cada tabla, cada nodo, cada conexión y cada campo, igual que en la Clase 8.

El archivo JSON puede utilizarse después para:

- comparar el resultado de la construcción manual;
- recuperar el workflow si se rompe durante la práctica;
- repetir la clase en otra instalación;
- disponer de una versión lista para importar.

En esta clase no usamos Google Sheets. La conexión con Google Sheets exigiría configurar un proyecto en Google Cloud y credenciales OAuth. Para mantener el foco en el agente de IA, usamos **Data Table**, una tabla interna de n8n que no requiere cuentas ni APIs externas.

> No se utilizan nodos `Code` ni JavaScript. Todas las transformaciones se realizan mediante `Edit Fields`, expresiones y nodos visuales.

## Resultado que vamos a construir

Una persona solicita inscribirse a un curso. En una tabla interna de n8n existen tres comisiones: una completa y dos con cupos disponibles.

El workflow deberá:

1. recibir los datos del alumno desde un `Manual Trigger`;
2. consultar la tabla de comisiones;
3. utilizar un agente de IA para elegir una comisión disponible;
4. guardar la inscripción en otra tabla;
5. descontar un cupo de la comisión elegida;
6. registrar al alumno en lista de espera si no hay vacantes;
7. utilizar otro agente para redactar un correo personalizado;
8. dejar el correo preparado para un futuro flujo de envío.

El flujo general será:

```text
Inicio manual
→ Datos del alumno
→ Agente asignador
   ├─ consulta Data Table como herramienta
   ├─ utiliza un modelo de lenguaje
   └─ devuelve una salida estructurada
→ ¿Hay cupo disponible?
   ├─ Sí → Registrar inscripción → Actualizar cupo
   └─ No → Registrar lista de espera
→ Agente redactor
→ Preparar flujo de envío
```

## 1. Crear las tablas internas de n8n

Las tablas se crean desde la interfaz de n8n, antes de construir el workflow.

1. Ir al **Project Overview**.
2. Abrir la sección **Data Tables**.
3. Seleccionar **Create Data Table**.
4. Crear la primera tabla con este nombre:

```text
Clase 9 - Comisiones
```

### 1.1. Columnas de `Clase 9 - Comisiones`

Agregar las columnas una por una:

| Columna | Tipo |
|---|---|
| `id_comision` | String |
| `curso` | String |
| `horario` | String |
| `cupo_total` | Number |
| `cupos_disponibles` | Number |
| `estado_comision` | String |

### 1.2. Filas de `Clase 9 - Comisiones`

Cargar tres filas:

| id_comision | curso | horario | cupo_total | cupos_disponibles | estado_comision |
|---|---|---|---:|---:|---|
| COM-01 | Introducción a IA | Lunes 18:00 | 20 | 0 | completa |
| COM-02 | Introducción a IA | Miércoles 18:00 | 20 | 3 | disponible |
| COM-03 | Introducción a IA | Sábado 10:00 | 20 | 8 | disponible |

La primera comisión está completa. Las otras dos tienen cupos.

5. Crear otra tabla:

```text
Clase 9 - Inscripciones
```

### 1.3. Columnas de `Clase 9 - Inscripciones`

Agregar las columnas una por una:

| Columna | Tipo |
|---|---|
| `id_inscripcion` | String |
| `nombre_alumno` | String |
| `correo_electronico` | String |
| `curso_solicitado` | String |
| `preferencia_horaria` | String |
| `id_comision` | String |
| `horario_comision` | String |
| `estado_inscripcion` | String |
| `motivo_asignacion` | String |

No cargar filas de alumnos. Las agregará el workflow.

## 2. Crear el workflow vacío

1. Crear un workflow nuevo.
2. No utilizar el archivo JSON.
3. Nombrar el workflow:

```text
Clase 9 - Inscripción con agente y Data Table
```

4. Trabajar sobre el canvas vacío.
5. Guardar antes de agregar nodos.

## 3. Crear el disparador manual

1. Agregar el nodo **Manual Trigger**.
2. Renombrarlo:

```text
Inicio manual
```

3. Dejarlo sin configuración adicional.

Este nodo permite ejecutar el workflow desde **Execute Workflow**, como en la Clase 8.

## 4. Crear los datos del alumno

1. Agregar un nodo **Edit Fields**.
2. Conectarlo desde `Inicio manual`.
3. Renombrarlo:

```text
Datos del alumno
```

4. Crear los siguientes campos, uno por uno:

| Campo | Tipo | Valor de prueba |
|---|---|---|
| `id_inscripcion` | String | `INS-001` |
| `nombre_alumno` | String | `Lucía Gómez` |
| `correo_electronico` | String | `lucia@example.com` |
| `curso_solicitado` | String | `Introducción a IA` |
| `preferencia_horaria` | String | `sin preferencia` |

5. Dejar desactivada la opción **Include Other Input Fields**.
6. Ejecutar solamente este nodo.
7. Revisar que el resultado tenga un item con los cinco campos.

Preguntar antes de continuar:

- ¿Cuántos campos tiene el item?
- ¿Qué campo identifica el curso?
- ¿Qué información todavía no conocemos?
- ¿Por qué la comisión no debe estar escrita en este nodo?

## 5. Crear el agente asignador

1. Agregar un nodo **AI Agent**.
2. Conectarlo desde `Datos del alumno`.
3. Renombrarlo:

```text
Agente asignador
```

### 5.1. Configurar el origen del prompt

En el nodo `Agente asignador`:

1. Seleccionar **Define below** como origen del mensaje del usuario.
2. Activar **Require Specific Output Format**.
3. Escribir:

```text
Datos del alumno:
- ID de inscripción: {{ $json.id_inscripcion }}
- Nombre: {{ $json.nombre_alumno }}
- Correo: {{ $json.correo_electronico }}
- Curso solicitado: {{ $json.curso_solicitado }}
- Preferencia horaria: {{ $json.preferencia_horaria }}

Consultá la herramienta "Consultar comisiones disponibles" antes de decidir.
Después devolvé únicamente la salida estructurada solicitada.
```

Para insertar una expresión:

1. activar el modo **Expression**;
2. escribir o seleccionar `$json`;
3. elegir el campo correspondiente;
4. comprobar la vista previa.

### 5.2. Configurar el mensaje de sistema

En **Options → System Message**, escribir:

```text
Sos el agente asignador de un curso. Tu tarea es consultar la herramienta "Consultar comisiones disponibles", buscar comisiones del curso solicitado y asignar una vacante.

Reglas:
1. Usá siempre la herramienta antes de decidir.
2. Considerá solamente comisiones del curso solicitado.
3. Descartá las comisiones con cupos_disponibles igual a 0.
4. Si hay preferencia horaria, respetala cuando exista una comisión disponible.
5. Si no hay preferencia, elegí la primera comisión disponible en el orden recibido.
6. No inventes IDs, horarios, cupos ni cursos.
7. Si no hay cupos, devolvé estado_inscripcion = lista_espera y dejá id_comision y horario_comision vacíos.
8. Si asignás una comisión, restá una unidad a cupos_disponibles y devolvé ese valor en cupos_disponibles_restantes.
9. Devolvé solamente la estructura definida por el parser.
```

Configurar además:

- **Max Iterations:** `5`;
- **Return Intermediate Steps:** desactivado;
- **Enable Streaming:** desactivado.

Todavía no ejecutar el agente: faltan el modelo, la herramienta y el parser.

## 6. Conectar el modelo de lenguaje

1. Agregar un nodo **OpenRouter Chat Model**.
2. Ubicarlo debajo del agente.
3. Renombrarlo:

```text
Modelo para los agentes
```

4. Seleccionar la credencial de OpenRouter disponible.
5. Seleccionar un modelo de conversación habilitado.
6. Configurar una temperatura baja, aproximadamente `0.2`.
7. Conectar la salida `Language Model` al puerto `Chat Model` de `Agente asignador`.

La temperatura baja ayuda a que la decisión sea más consistente.

## 7. Crear la herramienta de consulta

El agente debe leer la tabla de comisiones mediante una herramienta.

1. Agregar el nodo **Data Table Tool**.
2. Renombrarlo:

```text
Consultar comisiones disponibles
```

3. Seleccionar **Set Manually** en la descripción de la herramienta.
4. Escribir:

```text
Lee todas las filas de la tabla Clase 9 - Comisiones. Devuelve curso, horario, id_comision, cupos_disponibles y estado_comision. Usá esta herramienta antes de asignar una vacante.
```

5. Seleccionar:

- **Resource:** `Row`;
- **Operation:** `Get`;
- **Data table:** `Clase 9 - Comisiones`;
- **Return All:** activado.

6. No agregar filtros.
7. Conectar la salida `Tool` al puerto de herramientas de `Agente asignador`.

La conexión debe quedar separada de la conexión principal:

```text
Consultar comisiones disponibles ── herramienta ──> Agente asignador
Datos del alumno ─────────────────── entrada ────> Agente asignador
```

La herramienta no es una instrucción escrita en el prompt. Es una capacidad que el agente puede invocar.

## 8. Crear el parser de la asignación

1. Agregar el nodo **Structured Output Parser**.
2. Renombrarlo:

```text
Parser salida de asignación
```

3. Seleccionar **Generate from JSON Example**.
4. Pegar:

```json
{
  "id_inscripcion": "INS-001",
  "nombre_alumno": "Lucía Gómez",
  "correo_electronico": "lucia@example.com",
  "curso_solicitado": "Introducción a IA",
  "preferencia_horaria": "sin preferencia",
  "id_comision": "COM-02",
  "horario_comision": "Miércoles 18:00",
  "estado_inscripcion": "inscripto",
  "motivo_asignacion": "Primera comisión disponible",
  "cupos_disponibles_restantes": "2",
  "estado_comision": "disponible"
}
```

5. Conectar la salida `Output Parser` al puerto de parser de `Agente asignador`.

La estructura obliga al agente a entregar datos que los nodos posteriores puedan utilizar.

## 9. Probar el primer agente

Antes de agregar el resto del workflow:

1. Guardar el workflow.
2. Ejecutar el workflow.
3. Abrir la salida de `Agente asignador`.
4. Revisar si invocó `Consultar comisiones disponibles`.
5. Revisar la salida estructurada.

Para los datos de Lucía, el resultado esperado es conceptualmente:

```text
id_comision = COM-02
horario_comision = Miércoles 18:00
estado_inscripcion = inscripto
cupos_disponibles_restantes = 2
```

No continuar si:

- el agente no tiene modelo conectado;
- la herramienta no tiene seleccionada la tabla;
- el agente elige `COM-01`, que está completa;
- faltan campos en la salida;
- devuelve texto fuera de la estructura esperada.

## 10. Crear la decisión de cupo

1. Agregar un nodo **IF**.
2. Conectarlo desde `Agente asignador`.
3. Renombrarlo:

```text
¿Hay cupo disponible?
```

4. Crear una condición de tipo `String`:

```text
Valor izquierdo: {{ $json.output.estado_inscripcion }}
Operación: equals
Valor derecho: inscripto
```

La rama `true` será la de inscripción confirmada.
La rama `false` será la de lista de espera.

## 11. Registrar la inscripción en Data Table

Esta rama se ejecuta cuando el agente encontró una comisión.

1. Agregar un nodo **Data Table**.
2. Conectarlo a la salida `true` de `¿Hay cupo disponible?`.
3. Renombrarlo:

```text
Registrar inscripción
```

4. Configurar:

- **Resource:** `Row`;
- **Operation:** `Insert`;
- **Data table:** `Clase 9 - Inscripciones`.

5. En `Columns`, elegir el modo de mapeo manual.
6. Agregar las columnas una por una:

| Columna | Expresión |
|---|---|
| `id_inscripcion` | `{{ $json.output.id_inscripcion }}` |
| `nombre_alumno` | `{{ $json.output.nombre_alumno }}` |
| `correo_electronico` | `{{ $json.output.correo_electronico }}` |
| `curso_solicitado` | `{{ $json.output.curso_solicitado }}` |
| `preferencia_horaria` | `{{ $json.output.preferencia_horaria }}` |
| `id_comision` | `{{ $json.output.id_comision }}` |
| `horario_comision` | `{{ $json.output.horario_comision }}` |
| `estado_inscripcion` | `{{ $json.output.estado_inscripcion }}` |
| `motivo_asignacion` | `{{ $json.output.motivo_asignacion }}` |

7. Activar **Expression** en cada valor dinámico.
8. No escribir manualmente `COM-02`.

## 12. Actualizar el cupo

1. Agregar otro nodo **Data Table**.
2. Conectarlo desde `Registrar inscripción`.
3. Renombrarlo:

```text
Actualizar cupo de la comisión
```

4. Configurar:

- **Resource:** `Row`;
- **Operation:** `Update`;
- **Data table:** `Clase 9 - Comisiones`;
- **Must Match:** `All Conditions`.

5. Agregar una condición de coincidencia:

```text
Columna: id_comision
Condición: equals
Valor: {{ $('Agente asignador').item.json.output.id_comision }}
```

6. En `Columns`, agregar los campos que se actualizan:

| Campo | Expresión |
|---|---|
| `cupos_disponibles` | `{{ $('Agente asignador').item.json.output.cupos_disponibles_restantes }}` |
| `estado_comision` | `{{ $('Agente asignador').item.json.output.estado_comision }}` |

La expresión `$('Agente asignador')` recupera la salida del agente aunque el nodo inmediatamente anterior sea `Registrar inscripción`.

No utilizar una posición fija de fila: la coincidencia debe hacerse por `id_comision`.

## 13. Registrar la lista de espera

Esta rama se ejecuta cuando las tres comisiones están completas o no existe una comisión adecuada.

1. Agregar otro nodo **Data Table**.
2. Conectarlo a la salida `false` de `¿Hay cupo disponible?`.
3. Renombrarlo:

```text
Registrar lista de espera
```

4. Configurar:

- **Resource:** `Row`;
- **Operation:** `Insert`;
- **Data table:** `Clase 9 - Inscripciones`.

5. Agregar las mismas columnas del paso 11, una por una.
6. Utilizar las expresiones:

```text
{{ $json.output.id_inscripcion }}
{{ $json.output.nombre_alumno }}
{{ $json.output.correo_electronico }}
{{ $json.output.curso_solicitado }}
{{ $json.output.preferencia_horaria }}
{{ $json.output.id_comision }}
{{ $json.output.horario_comision }}
{{ $json.output.estado_inscripcion }}
{{ $json.output.motivo_asignacion }}
```

Cuando no haya cupo, el agente debe devolver vacíos `id_comision` y `horario_comision`.

Este nodo no debe conectarse a `Actualizar cupo de la comisión`.

## 14. Crear el agente redactor

El agente redactor recibe tanto la rama de inscripción confirmada como la rama de lista de espera.

1. Agregar un nuevo nodo **AI Agent**.
2. Conectar desde `Actualizar cupo de la comisión`.
3. Conectar también desde `Registrar lista de espera`.
4. Renombrarlo:

```text
Agente redactor
```

5. Seleccionar **Define below** como origen del mensaje.
6. Activar **Require Specific Output Format**.
7. Escribir:

```text
Datos de la inscripción:
- ID de inscripción: {{ $('Agente asignador').item.json.output.id_inscripcion }}
- Nombre: {{ $('Agente asignador').item.json.output.nombre_alumno }}
- Correo: {{ $('Agente asignador').item.json.output.correo_electronico }}
- Curso: {{ $('Agente asignador').item.json.output.curso_solicitado }}
- Comisión: {{ $('Agente asignador').item.json.output.id_comision }}
- Horario: {{ $('Agente asignador').item.json.output.horario_comision }}
- Estado: {{ $('Agente asignador').item.json.output.estado_inscripcion }}
- Motivo: {{ $('Agente asignador').item.json.output.motivo_asignacion }}

Redactá la carta personalizada y devolvé únicamente la salida estructurada.
```

### 14.1. Configurar el mensaje de sistema

En **Options → System Message**, escribir:

```text
Sos el agente redactor de una institución educativa. Redactá un correo claro, cordial y breve en español argentino formal.

Si estado_inscripcion es inscripto, confirmá la inscripción e incluí exactamente el curso, la comisión y el horario recibidos.

Si estado_inscripcion es lista_espera, no confirmes una vacante. Explicá que el pedido queda en lista de espera.

No inventes fechas, lugares, enlaces, requisitos ni datos que no estén en la entrada.
No uses Markdown.
Devolvé solamente destinatario, asunto, cuerpo y tipo_respuesta.
```

Configurar:

- **Max Iterations:** `3`;
- **Return Intermediate Steps:** desactivado;
- **Enable Streaming:** desactivado.

## 15. Conectar el modelo al segundo agente

Utilizar el mismo nodo `Modelo para los agentes`.

1. Conectar nuevamente su salida `Language Model`.
2. Llevarla al puerto `Chat Model` de `Agente redactor`.
3. Confirmar que el mismo modelo esté conectado a los dos agentes.

## 16. Crear el parser de la carta

1. Agregar otro nodo **Structured Output Parser**.
2. Renombrarlo:

```text
Parser salida de carta
```

3. Seleccionar **Generate from JSON Example**.
4. Pegar:

```json
{
  "destinatario": "lucia@example.com",
  "asunto": "Confirmación de inscripción al curso",
  "cuerpo": "Hola Lucía Gómez,\n\nTu inscripción fue registrada.",
  "tipo_respuesta": "confirmacion"
}
```

5. Conectar la salida `Output Parser` al puerto de parser de `Agente redactor`.

## 17. Preparar los datos para el envío

1. Agregar un nodo **Edit Fields**.
2. Conectarlo desde `Agente redactor`.
3. Renombrarlo:

```text
Preparar flujo de envío
```

4. Dejar desactivada la opción **Include Other Input Fields**.
5. Crear estos campos, uno por uno:

| Campo | Expresión |
|---|---|
| `id_inscripcion` | `{{ $('Agente asignador').item.json.output.id_inscripcion }}` |
| `nombre_alumno` | `{{ $('Agente asignador').item.json.output.nombre_alumno }}` |
| `id_comision` | `{{ $('Agente asignador').item.json.output.id_comision }}` |
| `estado_inscripcion` | `{{ $('Agente asignador').item.json.output.estado_inscripcion }}` |
| `destinatario` | `{{ $json.output.destinatario }}` |
| `asunto_correo` | `{{ $json.output.asunto }}` |
| `cuerpo_correo` | `{{ $json.output.cuerpo }}` |
| `tipo_respuesta` | `{{ $json.output.tipo_respuesta }}` |

El resultado es el contrato que recibiría un flujo de envío.

## 18. Prueba con una comisión disponible

Restaurar en `Clase 9 - Comisiones`:

```text
COM-01 → cupos_disponibles = 0
COM-02 → cupos_disponibles = 3
COM-03 → cupos_disponibles = 8
```

En `Datos del alumno`, usar:

```text
id_inscripcion = INS-001
nombre_alumno = Lucía Gómez
correo_electronico = lucia@example.com
curso_solicitado = Introducción a IA
preferencia_horaria = sin preferencia
```

Ejecutar el workflow completo y revisar los nodos en orden:

1. `Datos del alumno` recibe cinco campos.
2. `Agente asignador` consulta la herramienta.
3. `Parser salida de asignación` valida el resultado.
4. `¿Hay cupo disponible?` toma la rama `true`.
5. `Registrar inscripción` agrega una fila.
6. `Actualizar cupo de la comisión` modifica `COM-02`.
7. `Agente redactor` genera el correo.
8. `Parser salida de carta` valida asunto y cuerpo.
9. `Preparar flujo de envío` deja el correo listo.

Resultado esperado:

```text
comisión asignada: COM-02
horario: Miércoles 18:00
cupo anterior: 3
cupo nuevo: 2
estado: inscripto
correo: preparado, no enviado
```

## 19. Prueba con otro alumno

Cambiar en `Datos del alumno`:

```text
id_inscripcion = INS-002
nombre_alumno = Martín Rojas
correo_electronico = martin@example.com
```

Ejecutar nuevamente y verificar:

- que se agregue una segunda fila;
- que el cupo disminuya nuevamente;
- que el correo utilice el nombre de Martín;
- que no se reutilice el nombre de Lucía.

Restaurar los cupos antes de hacer más pruebas.

## 20. Prueba de lista de espera

Modificar temporalmente `Clase 9 - Comisiones`:

```text
COM-01 → cupos_disponibles = 0
COM-02 → cupos_disponibles = 0
COM-03 → cupos_disponibles = 0
```

En `Datos del alumno`, utilizar:

```text
id_inscripcion = INS-003
nombre_alumno = Ana Pérez
correo_electronico = ana@example.com
```

Ejecutar el workflow.

Verificar:

- `Agente asignador` devuelve `lista_espera`;
- `¿Hay cupo disponible?` toma la rama `false`;
- se agrega una fila a `Clase 9 - Inscripciones`;
- no se actualiza ninguna comisión;
- la carta informa lista de espera;
- no se confirma ningún horario.

Después de la prueba, restaurar los cupos.

## 21. Preguntas para observar el flujo

- ¿Qué datos vienen del alumno?
- ¿Qué datos consulta el agente?
- ¿Qué información decide el agente?
- ¿Qué información escriben los nodos `Data Table`?
- ¿Por qué el agente no debe inventar una comisión?
- ¿Por qué usamos un parser?
- ¿Qué diferencia hay entre `inscripto` y `lista_espera`?
- ¿Qué ocurre si el agente asigna una comisión pero falla la actualización del cupo?
- ¿Qué parte del correo debe ser generada y qué parte debe venir de la tabla?
- ¿Por qué separamos el agente asignador del agente redactor?

## 22. Límite del ejemplo

`Data Table` es adecuado para la práctica y para datos pequeños dentro de n8n. No debe presentarse como una base de datos transaccional completa.

Si dos ejecuciones intentan ocupar simultáneamente el último lugar, el flujo necesitaría un mecanismo adicional de control de concurrencia.

## 23. Criterio de finalización

La construcción manual está completa cuando:

- las dos tablas se crearon desde la interfaz de n8n;
- el workflow comenzó desde un canvas vacío;
- se creó cada nodo manualmente;
- se crearon los campos uno por uno;
- el agente consultó `Data Table` como herramienta;
- el parser devolvió una estructura válida;
- se descartó una comisión completa;
- se registró una inscripción disponible;
- se actualizó el cupo correcto;
- funcionó la rama de lista de espera;
- el segundo agente redactó una carta personalizada;
- la carta quedó preparada para el envío;
- no se utilizaron nodos `Code` ni JavaScript.

## 24. Archivo JSON de respaldo

El archivo:

```text
n8n/Clase 9 - Inscripcion con agente y Data Table.json
```

contiene la versión armada del workflow. No es el material principal de la práctica. Se conserva para comparar, recuperar o repetir el ejercicio después de haber construido el flujo manualmente.

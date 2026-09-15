# Clase 9 — Guía paso a paso
## Agente de IA para inscripciones en Google Sheets

**Duración estimada:** 90 minutos  
**Modo de trabajo:** importar el workflow preparado y configurarlo paso a paso  
**Archivo del workflow:** `n8n/Clase 9 - Inscripcion con agente y Google Sheets.json`

## Qué vamos a construir

Una persona solicita inscribirse a un curso. Google Sheets contiene tres comisiones, algunas completas y otras con cupos disponibles.

El workflow deberá:

1. recibir los datos de un alumno mediante un disparador manual;
2. consultar las comisiones en Google Sheets;
3. asignar una comisión disponible con un agente de IA;
4. registrar la inscripción;
5. actualizar el cupo de la comisión;
6. redactar una carta personalizada con otro agente;
7. dejar el correo preparado para un flujo de envío.

El nodo de Gmail queda deshabilitado durante la clase para evitar envíos accidentales.

> No vamos a crear los nodos manualmente. El JSON ya está preparado para importarlo. El trabajo de la clase será configurar, revisar y probar cada parte.

> El workflow no utiliza nodos `Code` ni JavaScript.

## 1. Preparar Google Sheets

Crear una planilla con dos hojas llamadas exactamente:

```text
Comisiones
Inscripciones
```

### 1.1. Hoja `Comisiones`

En la primera fila escribir estos encabezados, respetando mayúsculas, minúsculas y guiones bajos:

```text
id_comision | curso | horario | cupo_total | cupos_disponibles | estado_comision
```

Cargar tres filas de prueba:

```text
COM-01 | Introducción a IA | Lunes 18:00 | 20 | 0 | completa
COM-02 | Introducción a IA | Miércoles 18:00 | 20 | 3 | disponible
COM-03 | Introducción a IA | Sábado 10:00 | 20 | 8 | disponible
```

La primera comisión está completa. Las otras dos tienen cupos.

### 1.2. Hoja `Inscripciones`

En la primera fila escribir:

```text
id_inscripcion | nombre_alumno | correo_electronico | curso_solicitado | id_comision | horario_comision | estado_inscripcion | motivo_asignacion
```

No cargar datos debajo de los encabezados. El workflow agregará las filas.

## 2. Importar el JSON

1. Abrir n8n.
2. Ir a **Workflows**.
3. Elegir **Import from File**.
4. Seleccionar:

```text
n8n/Clase 9 - Inscripcion con agente y Google Sheets.json
```

5. Guardar el workflow con este nombre:

```text
Clase 9 - Agente de IA para inscripciones en Google Sheets
```

El workflow importado debe mostrar estos nodos principales:

```text
Inicio manual
→ Datos del alumno
→ Agente asignador
→ ¿Hay cupo disponible?
→ Registrar inscripción / Registrar lista de espera
→ Actualizar cupo de la comisión
→ Agente redactor
→ Preparar flujo de envío
→ Gmail - Enviar carta (deshabilitado)
```

También deben aparecer los nodos auxiliares conectados debajo de los agentes:

- `OpenRouter Chat Model`;
- `Consultar comisiones disponibles`;
- `Parser salida de asignación`;
- `Parser salida de carta`.

## 3. Configurar el modelo de lenguaje

Abrir `OpenRouter Chat Model`.

1. Seleccionar una credencial de OpenRouter.
2. Mantener un modelo de conversación disponible.
3. Mantener una temperatura baja, aproximadamente `0.2`.
4. Confirmar que el nodo esté conectado a:
   - `Agente asignador`;
   - `Agente redactor`.

Si el JSON fue importado en el n8n del VPS, puede aparecer seleccionada la credencial `OpenRouter account`. En otra instalación habrá que seleccionar la credencial correspondiente.

## 4. Configurar la herramienta de Google Sheets

Abrir `Consultar comisiones disponibles`.

Configurar:

- **Credential:** credencial OAuth2 de Google Sheets;
- **Resource:** `Sheet Within Document`;
- **Operation:** `Get Row(s)`;
- **Document:** la planilla creada en el paso 1;
- **Sheet:** `Comisiones`.

La herramienta debe leer todas las filas. No agregar filtros en esta primera versión.

Confirmar que la salida de la herramienta esté conectada al puerto de herramientas de `Agente asignador`.

### Regla que debe seguir el agente

El agente asignador ya contiene las instrucciones, pero hay que comprenderlas antes de probar:

1. consultar siempre la hoja;
2. considerar solamente el curso solicitado;
3. descartar comisiones con `cupos_disponibles` igual a `0`;
4. respetar la preferencia horaria si existe;
5. si no hay preferencia, elegir la primera comisión disponible;
6. no inventar IDs, horarios ni cupos;
7. si no hay vacantes, devolver `lista_espera`;
8. si asigna una vacante, calcular el cupo restante.

## 5. Revisar la salida estructurada del agente asignador

Abrir `Parser salida de asignación`.

El agente debe devolver estos campos:

```json
{
  "id_inscripcion": "INS-001",
  "nombre_alumno": "Lucía Gómez",
  "correo_electronico": "lucia@example.com",
  "curso_solicitado": "Introducción a IA",
  "id_comision": "COM-02",
  "horario_comision": "Miércoles 18:00",
  "estado_inscripcion": "inscripto",
  "motivo_asignacion": "Primera comisión disponible",
  "cupos_disponibles_restantes": "2",
  "estado_comision": "disponible"
}
```

No modificar los nombres de los campos. Los nodos siguientes utilizan esos nombres.

## 6. Revisar la condición de cupo

Abrir `¿Hay cupo disponible?`.

La condición debe evaluar:

```text
$json.output.estado_inscripcion igual a inscripto
```

La salida verdadera continúa por:

```text
Registrar inscripción → Actualizar cupo de la comisión
```

La salida falsa continúa por:

```text
Registrar lista de espera
```

No se debe actualizar una comisión cuando el estado sea `lista_espera`.

## 7. Configurar el registro de inscripción

Abrir `Registrar inscripción`.

Configurar:

- la misma credencial de Google Sheets;
- el mismo documento;
- la hoja `Inscripciones`;
- operación `Append Row`.

Verificar que el mapeo utilice estas columnas:

```text
id_inscripcion
nombre_alumno
correo_electronico
curso_solicitado
id_comision
horario_comision
estado_inscripcion
motivo_asignacion
```

El nodo `Registrar lista de espera` utiliza la misma hoja y las mismas columnas. La diferencia es que se ejecuta solamente cuando no hay vacante.

## 8. Configurar la actualización del cupo

Abrir `Actualizar cupo de la comisión`.

Configurar:

- la misma credencial de Google Sheets;
- el mismo documento;
- la hoja `Comisiones`;
- operación `Update Row`;
- columna de coincidencia: `id_comision`.

El nodo debe actualizar solamente:

```text
id_comision
cupos_disponibles
estado_comision
```

La comisión que se actualiza debe ser la misma que devolvió `Agente asignador`.

## 9. Revisar el agente redactor

`Agente redactor` recibe la decisión del agente asignador.

Debe cumplir estas reglas:

- redactar en español argentino formal y cordial;
- confirmar la inscripción solamente si el estado es `inscripto`;
- incluir el curso, la comisión y el horario recibidos;
- si el estado es `lista_espera`, no confirmar una vacante;
- no inventar fechas, lugares, enlaces ni requisitos;
- devolver destinatario, asunto, cuerpo y tipo de respuesta.

El resultado se valida en `Parser salida de carta`.

## 10. Revisar la preparación del envío

Abrir `Preparar flujo de envío` y verificar que produzca:

```text
destinatario
asunto_correo
cuerpo_correo
estado_inscripcion
```

El nodo `Gmail - Enviar carta (deshabilitado)` muestra dónde continuaría el flujo.

No habilitarlo durante la primera prueba.

## 11. Cargar los datos de prueba

Abrir `Datos del alumno` y utilizar estos valores:

```text
id_inscripcion = INS-001
nombre_alumno = Lucía Gómez
correo_electronico = lucia@example.com
curso_solicitado = Introducción a IA
preferencia_horaria = sin preferencia
```

El resto del workflow ya está conectado.

## 12. Ejecutar la primera prueba

1. Guardar el workflow.
2. Seleccionar **Execute Workflow**.
3. Revisar cada nodo en orden.
4. Abrir la salida de `Agente asignador`.
5. Confirmar que eligió `COM-02`.
6. Revisar la nueva fila en `Inscripciones`.
7. Revisar la hoja `Comisiones`.
8. Confirmar que `COM-02` pasó de `3` a `2` cupos.
9. Revisar el texto generado por `Agente redactor`.
10. Confirmar que Gmail continúa deshabilitado.

Resultado esperado:

```text
comisión asignada: COM-02
estado: inscripto
cupos restantes: 2
correo: preparado, no enviado
```

## 13. Ejecutar una segunda prueba

Cambiar solamente los datos del alumno:

```text
id_inscripcion = INS-002
nombre_alumno = Martín Rojas
correo_electronico = martin@example.com
```

Ejecutar nuevamente y verificar que el cupo de la comisión seleccionada disminuya en una unidad.

Antes de repetir varias veces, restaurar manualmente los cupos de la planilla para no agotar las comisiones de prueba.

## 14. Probar la lista de espera

Modificar temporalmente la hoja `Comisiones`:

```text
COM-01 → cupos_disponibles = 0
COM-02 → cupos_disponibles = 0
COM-03 → cupos_disponibles = 0
```

Ejecutar el workflow.

Debe ocurrir lo siguiente:

- `estado_inscripcion = lista_espera`;
- se registra una fila en `Inscripciones`;
- no se actualiza ninguna comisión;
- la carta no confirma una vacante.

Después de la prueba, restaurar los valores de cupo.

## 15. Configurar Gmail después de la revisión

Este paso es opcional y posterior a la clase.

1. Abrir `Gmail - Enviar carta (deshabilitado)`.
2. Seleccionar una credencial Gmail.
3. Revisar destinatario, asunto y cuerpo.
4. Hacer una primera prueba con una cuenta docente.
5. Habilitar el nodo solamente después de revisar el contenido.

## Errores frecuentes

### Falta una credencial

Seleccionar la credencial correspondiente dentro del nodo. Las credenciales no se incluyen en el JSON.

### No encuentra la planilla

Revisar que se haya seleccionado el documento correcto y que las hojas se llamen exactamente `Comisiones` e `Inscripciones`.

### No encuentra una columna

Comparar los encabezados de la primera fila con los nombres indicados en este documento. No agregar tildes, espacios ni cambios de mayúsculas.

### El agente inventa una comisión

Revisar que `Consultar comisiones disponibles` esté conectado al puerto de herramientas de `Agente asignador` y que el agente tenga instrucciones para consultar la herramienta antes de decidir.

### El cupo se actualiza mal

Revisar que `Actualizar cupo de la comisión` utilice el `id_comision` devuelto por `Agente asignador` y no un valor escrito manualmente.

### Se envía un correo accidentalmente

Confirmar que `Gmail - Enviar carta (deshabilitado)` permanezca deshabilitado durante toda la práctica.

## Criterio de finalización

La clase está completa cuando:

- el JSON fue importado;
- el modelo está conectado a los dos agentes;
- el agente asignador consulta Google Sheets;
- una comisión completa es descartada;
- una comisión disponible es asignada;
- la inscripción se guarda;
- el cupo se actualiza;
- la lista de espera funciona;
- el agente redactor genera una carta coherente;
- la carta queda preparada pero no enviada;
- no se utilizaron nodos `Code` ni JavaScript.

## Límite del ejemplo

Google Sheets es suficiente para la práctica, pero no garantiza una reserva transaccional si varias personas se inscriben al mismo tiempo por el último cupo. Un sistema real necesitaría una actualización atómica o una base de datos con control de concurrencia.

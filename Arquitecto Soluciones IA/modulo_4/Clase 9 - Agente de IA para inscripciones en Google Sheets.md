# Clase 9 — Agente de IA para inscripciones en Google Sheets

**Duración:** 90 minutos  
**Nivel:** inicial-intermedio  
**Modalidad:** construcción guiada y pruebas manuales  
**Producto:** un workflow que asigna un alumno a una comisión con cupo, registra la inscripción en Google Sheets, actualiza el cupo y redacta una carta personalizada.

## Continuidad con la Clase 8

En la Clase 8 se construyó un workflow lineal con `Manual Trigger`, `Edit Fields`, items, JSON, expresiones y contratos de datos.

En esta clase se conserva el disparador manual. No necesitamos un formulario ni una llamada HTTP: los datos del alumno se cargan en un nodo `Edit Fields` para concentrarnos en la parte más importante:

- configurar un nodo `AI Agent`;
- conectar un modelo de lenguaje;
- darle acceso a una herramienta de Google Sheets;
- exigir una salida estructurada;
- encadenar la decisión del agente con nodos de persistencia;
- invocar otro agente para redactar una carta personalizada.

> No se utiliza ningún nodo `Code` ni JavaScript. Las transformaciones se realizan con campos, expresiones y nodos visuales.

## Pregunta central

> ¿Cómo puede un agente consultar las comisiones disponibles, asignar una vacante y preparar una comunicación personalizada sin inventar información?

## Objetivos de aprendizaje

Al finalizar, cada estudiante podrá:

- distinguir entre un nodo de lenguaje y un agente con herramientas;
- configurar un `AI Agent` con instrucciones de sistema;
- conectar un modelo de lenguaje al agente;
- conectar Google Sheets como herramienta de consulta;
- pedir al agente una respuesta con un contrato JSON explícito;
- usar una salida del agente en nodos posteriores;
- registrar una inscripción en una planilla;
- actualizar el cupo de la comisión asignada;
- separar la decisión de inscripción de la redacción del correo;
- reconocer por qué una planilla no ofrece una reserva transaccional perfecta.

## Escenario

Una persona solicita inscribirse a un curso. Existen tres comisiones:

- una ya está completa;
- dos tienen cupos disponibles.

El agente debe consultar la hoja `Comisiones`, descartar las comisiones completas y asignar una comisión disponible. Si el alumno no indica una preferencia horaria, se elige la primera comisión disponible según el orden de la planilla.

Después de la decisión:

1. se registra la inscripción en la hoja `Inscripciones`;
2. se actualizan `cupos_disponibles` y `estado_comision`;
3. un segundo agente redacta una carta personalizada;
4. el resultado queda preparado para el flujo de envío.

El nodo de Gmail se deja deshabilitado en el material para evitar envíos durante la clase.

## Estructura de Google Sheets

Crear una planilla con dos hojas.

### Hoja `Comisiones`

La primera fila debe contener exactamente estos encabezados:

```text
id_comision | curso | horario | cupo_total | cupos_disponibles | estado_comision
```

Cargar estos datos de prueba:

```text
COM-01 | Introducción a IA | Lunes 18:00 | 20 | 0 | completa
COM-02 | Introducción a IA | Miércoles 18:00 | 20 | 3 | disponible
COM-03 | Introducción a IA | Sábado 10:00 | 20 | 8 | disponible
```

### Hoja `Inscripciones`

La primera fila debe contener:

```text
id_inscripcion | nombre_alumno | correo_electronico | curso_solicitado | id_comision | horario_comision | estado_inscripcion | motivo_asignacion | fecha_registro
```

## Workflow

```text
Inicio manual
    ↓
Datos del alumno
    ↓
Agente asignador
    ├── herramienta: Consultar comisiones disponibles
    ├── modelo de lenguaje
    └── salida JSON estructurada
    ↓
¿Estado = inscripto?
    ├── Sí → Registrar inscripción → Actualizar cupo
    └── No → Registrar lista de espera
                         ↓
                 Agente redactor
                         ↓
              Preparar flujo de envío
                         ↓
             Gmail deshabilitado
```

El agente decide. Los nodos de Google Sheets efectúan las escrituras de forma explícita. Esta separación hace que el flujo sea más fácil de revisar y reduce el riesgo de que el modelo escriba datos sin una etapa visible de persistencia.

## Preparación del entorno

1. Iniciar el n8n local o el n8n del VPS.
2. Confirmar que existe una credencial de modelo de lenguaje.
3. Crear o seleccionar una credencial OAuth2 de Google Sheets.
4. Tener disponible el ID de la planilla.
5. No activar el workflow todavía.

En el n8n del VPS utilizado para preparar este material existe una credencial `OpenRouter account`. El JSON la referencia para el modelo. La credencial de Google Sheets no se incluye porque debe autorizarse desde la cuenta que utilizará cada instalación.

## Importar el workflow

1. Abrir **Workflows** en n8n.
2. Elegir **Import from File**.
3. Seleccionar:

```text
n8n/Clase 9 - Inscripcion con agente y Google Sheets.json
```

4. Guardar el workflow con el nombre:

```text
Clase 9 - Inscripción con agente y Google Sheets
```

El JSON contiene valores de reemplazo como `REEMPLAZAR_ID_DE_LA_PLANILLA`. No son credenciales ni datos reales.

## Paso a paso

### Paso 1 — Revisar los datos del alumno

Abrir `Datos del alumno` y comprobar que contiene:

```text
id_inscripcion = INS-001
nombre_alumno = Lucía Gómez
correo_electronico = lucia@example.com
curso_solicitado = Introducción a IA
preferencia_horaria = sin preferencia
```

Para repetir la prueba, cambiar solamente el identificador y los datos del alumno.

### Paso 2 — Configurar el modelo

En `OpenRouter Chat Model`:

1. seleccionar la credencial disponible;
2. usar un modelo de conversación habilitado;
3. comenzar con una temperatura baja, por ejemplo `0.2`;
4. mantener el modelo conectado a los dos agentes.

La temperatura baja ayuda a que la asignación y la redacción sean más previsibles.

### Paso 3 — Configurar la herramienta de consulta

Abrir `Consultar comisiones disponibles` y seleccionar:

- credencial de Google Sheets;
- documento correspondiente a la planilla;
- hoja `Comisiones`;
- operación `Get Row(s)`.

La herramienta debe leer todas las filas. No filtrar por una comisión específica: el agente debe observar las tres y aplicar la regla de disponibilidad.

### Paso 4 — Leer las instrucciones del agente asignador

El agente recibe los datos del alumno y tiene esta responsabilidad:

- consultar siempre la herramienta;
- considerar solamente filas del curso solicitado;
- descartar filas con `cupos_disponibles` igual a `0`;
- respetar la preferencia horaria si existe;
- si no existe, elegir la primera comisión disponible;
- calcular el cupo restante después de la inscripción;
- no inventar comisiones, horarios ni cupos;
- devolver solamente la estructura definida por el parser.

La salida esperada para el ejemplo es conceptualmente:

```json
{
  "id_inscripcion": "INS-001",
  "id_comision": "COM-02",
  "horario_comision": "Miércoles 18:00",
  "estado_inscripcion": "inscripto",
  "cupos_disponibles_restantes": "2",
  "estado_comision": "disponible"
}
```

### Paso 5 — Revisar la condición

El nodo `¿Hay cupo disponible?` comprueba si `estado_inscripcion` es igual a `inscripto`.

- La salida `true` registra la inscripción y actualiza la comisión.
- La salida `false` registra el pedido como `lista_espera` sin modificar una comisión.

### Paso 6 — Registrar la inscripción

En `Registrar inscripción` seleccionar:

- la misma credencial de Google Sheets;
- el mismo documento;
- la hoja `Inscripciones`;
- operación `Append Row`.

Verificar que los nombres de las columnas coincidan exactamente con la primera fila de la hoja.

### Paso 7 — Actualizar el cupo

En `Actualizar cupo de la comisión` seleccionar:

- documento y credencial de Google Sheets;
- hoja `Comisiones`;
- operación `Update Row`;
- columna de coincidencia: `id_comision`.

El nodo recibe del agente:

- `id_comision`;
- `cupos_disponibles_restantes`;
- `estado_comision`.

No se debe actualizar una comisión diferente de la que devolvió el agente.

### Paso 8 — Redactar la carta

El `Agente redactor` recibe el resultado de la asignación. Debe:

- usar únicamente la información recibida;
- confirmar la comisión solamente cuando el estado sea `inscripto`;
- informar lista de espera cuando no haya cupo;
- utilizar un tono institucional, claro y cordial;
- devolver destinatario, asunto, cuerpo y tipo de respuesta.

No debe inventar fechas, lugares, enlaces ni requisitos que no estén en los datos.

### Paso 9 — Preparar el envío

`Preparar flujo de envío` deja cuatro campos listos:

```text
destinatario
asunto_correo
cuerpo_correo
estado_inscripcion
```

El nodo `Gmail - Enviar carta (deshabilitado)` muestra dónde continuaría el flujo. Para la clase no se habilita.

Si se desea probar el envío posteriormente:

1. configurar una credencial Gmail;
2. revisar el destinatario;
3. probar primero con una cuenta docente;
4. habilitar el nodo solamente después de revisar el cuerpo generado.

## Prueba guiada

### Prueba 1 — Comisión disponible

Usar los datos de Lucía Gómez.

Resultado esperado:

- se asigna `COM-02`;
- el cupo pasa de `3` a `2`;
- se agrega una fila en `Inscripciones`;
- se genera una carta de confirmación;
- el nodo Gmail permanece sin enviar.

### Prueba 2 — Otra inscripción

Cambiar:

```text
id_inscripcion = INS-002
nombre_alumno = Martín Rojas
correo_electronico = martin@example.com
```

Verificar que se conserva la comisión elegida y que el cupo vuelve a disminuir en una unidad.

### Prueba 3 — Sin cupos

Cambiar temporalmente los tres valores `cupos_disponibles` a `0`.

Resultado esperado:

- `estado_inscripcion = lista_espera`;
- no se actualiza una comisión;
- se registra el pedido en `Inscripciones`;
- la carta no confirma una vacante.

Después de la prueba, restaurar los datos de la planilla.

## Conversación con los alumnos

- ¿Qué información consulta el agente y qué información escribe un nodo posterior?
- ¿Por qué no conviene permitir que el agente invente un `id_comision`?
- ¿Qué diferencia hay entre decidir una comisión y actualizar una fila?
- ¿Qué pasaría si dos personas se inscriben al mismo tiempo por el último cupo?
- ¿Qué parte del mensaje debe ser generada y qué parte debe venir de la planilla?
- ¿Por qué separamos el agente asignador del agente redactor?

## Límite importante

Google Sheets es suficiente para una demostración y para volúmenes pequeños, pero no funciona como una reserva transaccional robusta. Si varias ejecuciones modifican el mismo último cupo al mismo tiempo, podría producirse una doble asignación.

En un sistema real habría que agregar una reserva controlada, una base de datos con operaciones atómicas o una revisión posterior antes de confirmar la vacante.

## Criterios de finalización

La práctica está completa cuando:

- el agente consulta las tres comisiones;
- descarta la comisión completa;
- devuelve una salida estructurada;
- se registra una fila en `Inscripciones`;
- se actualiza el cupo correcto;
- el segundo agente redacta una carta coherente;
- la carta queda preparada para el envío;
- el workflow no contiene nodos `Code` ni JavaScript;
- el nodo Gmail sigue deshabilitado durante la clase.

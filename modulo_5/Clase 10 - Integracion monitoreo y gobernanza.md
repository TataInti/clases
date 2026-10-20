# Clase 10 — Integración: monitoreo y gobernanza de sistemas de IA

**Duración:** 120 minutos  
**Modalidad:** explicación guiada, demostración y taller integrador  
**Producto:** mapa de arquitectura y ficha de monitoreo, revisión humana y trazabilidad  
**Continuidad:** clases 3, 4, 7, 8 y 9 del módulo 5

## Pregunta central

**¿Cómo comprobamos que un sistema de IA sigue siendo útil y que sus decisiones se pueden revisar?**

## Objetivos de aprendizaje

Al finalizar, vas a poder:

- distinguir un cambio en los datos de una caída medida en el rendimiento;
- interpretar MAE, RMSE y R² como respuestas a preguntas distintas sobre una regresión;
- proponer un ciclo de monitoreo, diagnóstico, validación y mejora;
- explicar cuándo una solución necesita RAG y cuándo necesita memoria conversacional;
- incluir una intervención humana en un flujo de agente;
- diseñar un registro que permita reconstruir una decisión y su resultado;
- defender una arquitectura con evidencia, límites y responsabilidades explícitas.

## Idea central

Un sistema de IA continúa expuesto a cambios después de su puesta en marcha. El monitoreo permite detectar señales; la evaluación con resultados reales ayuda a medir el rendimiento; y la gobernanza define quién investiga, decide y documenta los cambios.

En los agentes, memoria, recuperación de información, herramientas y supervisión humana resuelven problemas diferentes. Una arquitectura clara permite saber qué componente intervino y qué evidencia sustenta una acción.

## Agenda

| Tiempo | Momento | Propósito |
|---:|---|---|
| 0–8 min | Apertura | Recordar qué puede cambiar después del despliegue |
| 8–25 min | Cambios y señales | Distinguir cambio en datos y deterioro de rendimiento |
| 25–40 min | Métricas de regresión | Elegir e interpretar métricas según el costo del error |
| 40–52 min | Ciclo de mejora | Definir investigación y validación antes de actualizar |
| 52–65 min | Arquitectura de agente | Diferenciar RAG, memoria, herramientas y HITL |
| 65–78 min | Demostración docente | Recorrer el caso integrador del centro cultural |
| 78–108 min | Trabajo grupal | Diseñar seguimiento y controles para el sistema |
| 108–118 min | Defensa breve | Justificar elecciones y límites |
| 118–120 min | Cierre | Anotar una señal prioritaria |

## 1. Apertura — 8 minutos

Pensá en un sistema que funcionaba bien cuando se publicó. Anotá tres cosas que podrían cambiar con el tiempo: una relacionada con los datos, una con el uso de la aplicación y una con las reglas de la organización.

## 2. Cambios en los datos y en el rendimiento — 17 minutos

### Deriva de datos

Se habla de **deriva de datos** cuando las características o la distribución de los datos de entrada cambian con respecto a los datos de referencia. Es una señal para investigar; por sí sola no prueba que el modelo ahora cometa más errores.

### Rendimiento observado

Para saber cómo predice el modelo en la operación, necesitamos comparar sus predicciones con resultados reales cuando esos resultados estén disponibles. Una variación de la entrada y una variación del error están relacionadas, pero no significan lo mismo.

| Evidencia | Qué permite decir | Qué todavía no permite concluir |
|---|---|---|
| Cambió la frecuencia de una categoría de entrada | La composición de los datos es distinta | Que la calidad del modelo necesariamente cayó |
| Aumentó el error frente a resultados reales | El rendimiento medido empeoró en el período observado | Qué cambio fue la causa |
| Los errores se concentran en un grupo de registros | El promedio general puede ocultar diferencias | Que todas las personas se ven afectadas igual |

## 3. Métricas de regresión — 15 minutos

Las métricas ofrecen perspectivas diferentes sobre los errores numéricos:

| Métrica | Lectura sencilla | Cuándo ayuda |
|---|---|---|
| MAE | Error absoluto promedio, en las unidades del objetivo | Comunicar cuánto se desvía una predicción en promedio |
| RMSE | Error con más peso para desviaciones grandes | Vigilar errores grandes que sean especialmente costosos |
| R² | Comparación con una referencia basada en la variabilidad observada | Entender cuánto aporta el modelo frente a predecir la media en esos datos |

No hay una métrica universalmente mejor. La elección depende de la decisión y del costo de distintos tipos de error. Se pueden informar varias métricas si se explica qué pregunta responde cada una.

## 4. Ciclo de monitoreo y mejora — 12 minutos

1. Definir qué datos, resultados y grupos se van a observar.
2. Guardar una referencia para comparar los datos que llegan.
3. Medir el rendimiento cuando se disponga de resultados reales.
4. Investigar los cambios y errores antes de atribuir una causa.
5. Evaluar una posible actualización con datos que no se usaron para ajustarla.
6. Documentar quién aprobó el cambio, cómo se comprobó y cómo se volvería atrás si empeora.
7. Seguir midiendo después de actualizar.

Una alerta no obliga a reentrenar. Primero hay que validar los datos, comprender el problema y decidir si un cambio es necesario.

## 5. Integrar componentes de agentes — 13 minutos

| Componente | Qué resuelve | Qué no reemplaza |
|---|---|---|
| RAG | Recuperar fragmentos pertinentes de fuentes aprobadas antes de redactar | El historial de la conversación o la verificación de una acción |
| Memoria | Conservar información necesaria para continuar la interacción | La fuente oficial de datos del negocio |
| Herramientas | Consultar o modificar sistemas con operaciones delimitadas | Los controles de acceso y validaciones de la aplicación |
| HITL | Dar a una persona un punto real de revisión o aprobación | Una política de permisos o un registro de lo ocurrido |
| Trazabilidad | Reconstruir fuentes, propuesta, decisión, aprobación y resultado | La prueba de que la decisión fue correcta por el solo hecho de existir un registro |

### Gobernanza y registro de eventos

ISO/IEC 42001:2023 define un marco de sistema de gestión para establecer, implementar, mantener y mejorar la gestión responsable de sistemas de IA. En esta clase lo conectamos con decisiones concretas: asignar responsables, identificar riesgos, definir controles, observar resultados y revisar si los controles funcionan. Un registro de eventos aporta evidencia para analizar el funcionamiento; por sí solo no demuestra cumplimiento ni que una decisión haya sido correcta.

Ejemplo didáctico de un registro para una solicitud de reserva:

```json
{
  "session_id": "SES-204",
  "event": "reserva_propuesta",
  "source_ref": "politica_reservas_v3",
  "tool": "crear_reserva",
  "decision": "reservar sala 2 el jueves a las 16",
  "human_review": "aprobada",
  "result": "reserva registrada"
}
```

El registro debe ser suficiente para revisar el evento sin guardar datos personales innecesarios. La organización define quién accede, cuánto tiempo conserva los registros y cómo corrige errores.

## 6. Demostración docente — 13 minutos

### Centro cultural y agenda de actividades

Un centro cultural quiere estimar la asistencia semanal para organizar recursos y ofrecer un asistente que responda consultas sobre actividades y prepare solicitudes de reserva.

El diseño contempla:

- un modelo de regresión que estima asistentes por semana;
- un seguimiento de datos de entrada y errores frente a asistencias reales;
- una base documental aprobada con horarios, condiciones y descripciones;
- recuperación RAG para responder preguntas con esa información;
- memoria acotada para mantener preferencias durante la conversación;
- revisión humana antes de confirmar una reserva que afecta la disponibilidad;
- un registro de la fuente, la propuesta, la decisión humana y el resultado.

Recorré el flujo y preguntá qué evidencia permitiría evaluar cada parte. Si cambia la frecuencia de los eventos, esa observación inicia una revisión; no indica automáticamente la causa ni demuestra por sí misma que las predicciones hayan empeorado.

## 7. Trabajo grupal — 30 minutos

### Desafío: diseñar el seguimiento del sistema

En equipos, diseñen una ficha de arquitectura y monitoreo para el centro cultural o para otro servicio cotidiano que elijan. No usen los escenarios del examen.

1. Definan qué predice el modelo y qué resultados reales servirían para medirlo.
2. Elijan una métrica principal y expliquen qué errores quieren entender.
3. Especifiquen una señal de cambio en los datos y una comprobación del rendimiento.
4. Indiquen qué fuente consultaría el RAG y qué información conservaría la memoria.
5. Marquen una acción que necesita revisión humana y qué información verá quien decide.
6. Definan qué eventos registrarían para reconstruir la operación y revisar una alerta. Redacten un registro de ejemplo con identificador de sesión, herramienta, decisión, estado de revisión y resultado; usen datos ficticios.
7. Anoten un límite: qué no se puede afirmar sin más evidencia.

**Entrega del equipo:** un diagrama de componentes y una ficha de seguimiento con señal, métrica, responsable, revisión humana y evidencia a registrar.

| Componente | Qué observa o hace | Señal o métrica | Quién revisa | Acción posible |
|---|---|---|---|---|
| Modelo numérico |  |  |  |  |
| Recuperación y memoria |  |  |  |  |
| Acción del agente |  |  |  |  |
| Aprobación y trazabilidad |  |  |  |  |

## 8. Defensa breve — 10 minutos

Cada equipo presenta una decisión de diseño y un límite de su análisis. El grupo revisa si:

- la métrica responde a la pregunta planteada;
- la señal de cambio se distingue del rendimiento medido;
- la fuente de RAG y la memoria cumplen funciones diferentes;
- la acción se pausa antes del punto que requiere aprobación;
- el registro permite saber qué ocurrió y quién intervino.

## 9. Cierre — 2 minutos

Completá: **“Si observo ___, primero buscaría ___ antes de recomendar un cambio.”**

## Criterio de logro

La propuesta distingue señales de rendimiento, relaciona métricas con decisiones, asigna responsabilidades, conserva una revisión humana donde corresponde y documenta qué evidencia falta.

## Referencias

- [ISO/IEC 42001:2023 — página oficial de la norma](https://www.iso.org/es/norma/42001)
- [ISO — explicación institucional de los sistemas de gestión de IA](https://www.iso.org/insights/iso-42001-explained)

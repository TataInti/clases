# Repaso guiado — Modelos, asistentes y agentes en Circo Bus

En esta exposición vas a recorrer tres temas del curso: un modelo que estima un valor numérico, un asistente que consulta documentos y recuerda la conversación, y un agente que puede ejecutar acciones con herramientas.

El caso de **Circo Bus** conecta esos temas. La empresa estima la cantidad de pasajeros por recorrido, atiende consultas con un asistente y usa agentes para organizar tareas de mantenimiento. Después del repaso, el [notebook de apoyo](Clase%20de%20repaso%20-%20Trabajo%20final%20integrador.ipynb) presenta tres casos nuevos para responder y recibir una devolución formativa orientativa de una IA mediante OpenRouter.

## 1. Un modelo que estima la cantidad de pasajeros

Circo Bus quiere anticipar cuántos pasajeros usarán cada recorrido cada día para distribuir unidades y planificar frecuencias. Para entrenar el modelo utiliza registros históricos con recorrido, día, horario, tipo de tarifa y cantidad real de pasajeros.

### Cómo aprende el modelo

En el **aprendizaje supervisado**, cada ejemplo incluye datos de entrada y un resultado conocido que el modelo aprende a estimar. En Circo Bus, el recorrido, el día, el horario y la tarifa son **variables predictoras**; la cantidad real de pasajeros es la **etiqueta** o resultado objetivo.

Como la salida es un número, el problema es una **regresión**. Los otros paradigmas se distinguen por la información con la que aprende el sistema:

- En el **aprendizaje no supervisado**, no se proporciona una respuesta correcta por ejemplo; se buscan grupos o patrones en los datos.
- En el **aprendizaje por refuerzo**, un agente prueba acciones y aprende de los resultados o recompensas que recibe.

### Qué cambia cuando llegan datos distintos

Circo Bus incorpora recorridos nuevos y modifica algunas tarifas. Las combinaciones de recorrido, día y horario aparecen poco en los datos históricos. Aunque el código y los servidores no cambien, el modelo ahora recibe ejemplos distintos de los que conocía.

La **deriva de datos** (*data drift*) es un cambio en la distribución de las entradas. La **deriva de concepto** es un cambio en la relación entre esas entradas y el resultado: por ejemplo, si recorridos con las mismas características empiezan a tener una cantidad de pasajeros sistemáticamente distinta.

La **degradación del rendimiento** se confirma cuando las predicciones se comparan con los resultados reales y el error aumenta. La deriva de datos puede ser una señal temprana, pero por sí sola no prueba que el error haya crecido.

El **ciclo de vida de los datos** incluye recopilar y revisar información, preparar datos de entrenamiento, evaluar el modelo, observar su uso y decidir si hace falta actualizarlo. La **validación** ayuda a comparar opciones; el conjunto de **prueba** se reserva para informar el resultado final. Un cambio en los datos pide investigación antes de actualizar el modelo automáticamente.

### Tres métricas para leer el error

En cinco días, el modelo estimó 20, 19, 14, 22 y 30 pasajeros; viajaron 18, 21, 15, 32 y 27. Las diferencias absolutas fueron 2, 2, 1, 10 y 3 pasajeros.

| Métrica | Qué resume | Lectura para Circo Bus |
|---|---|---|
| **MAE** — error absoluto medio | Promedio del tamaño de los errores, en las unidades del resultado | El error absoluto promedio es de **3,6 pasajeros**. |
| **RMSE** — raíz del error cuadrático medio | Promedio del error, dando más peso a los desvíos grandes | Da más peso al día con un error de 10 pasajeros; aquí resulta aproximadamente **4,86 pasajeros**. |
| **R²** | Compara el modelo con una referencia que siempre predice el promedio de pasajeros | En este ejemplo es aproximadamente **0,38**. No significa que el modelo acierte el 38 % de las veces. |

El MAE es fácil de comunicar. El RMSE ayuda a notar errores grandes. R² describe cuánto mejora el modelo frente a la referencia del promedio, pero no muestra el error en pasajeros. Estas métricas no distinguen por sí solas entre sobreestimar y subestimar; para decidir qué importa más hay que considerar el efecto de cada error en la planificación.

## 2. Un asistente que consulta y recuerda

El asistente de Circo Bus responde preguntas sobre recorridos, equipaje y condiciones de viaje. Consulta manuales y políticas extensos, y mantiene el contexto de cada conversación.

### LLM, tokens y contexto

Un **LLM** es un modelo que procesa y genera texto. El texto se representa en **tokens**, unidades que pueden ser palabras, partes de palabras o signos. La cantidad de tokens influye en el costo y en cuánto texto entra en una consulta.

La **ventana de contexto** es el límite de información que el modelo puede considerar en una interacción. Si Circo Bus copia manuales completos en cada consulta, consume ese espacio y hace más difícil concentrar la respuesta en la información pertinente.

### Memoria conversacional y RAG

La **memoria conversacional** conserva el contexto necesario de una sesión, como la preferencia de una persona por viajar en un horario determinado. La aplicación debe relacionar ese dato con la conversación correcta y recuperarlo mientras sea útil.

**RAG** (*Retrieval-Augmented Generation*, generación aumentada por recuperación) permite buscar en documentos y presentar al modelo fragmentos relevantes. La memoria sigue el hilo de la conversación; RAG recupera conocimiento de manuales y políticas.

El flujo RAG tiene tres partes:

1. **Preparar los documentos.** Se seleccionan fuentes confiables, se dividen en fragmentos (*chunks*) y se guarda información como título, sección y versión. Cada fragmento puede convertirse en un **embedding**, una representación numérica que permite comparar semejanzas entre textos. Los embeddings se organizan en un **índice vectorial**.
2. **Recuperar fragmentos.** La pregunta se compara con el índice y se seleccionan pasajes pertinentes, aplicando filtros de fuente o vigencia cuando corresponda.
3. **Generar una respuesta fundamentada.** El modelo recibe la consulta y los pasajes seleccionados. La respuesta se vincula con esas fuentes; si no hay evidencia suficiente o las fuentes se contradicen, el asistente informa esa limitación.

La recuperación puede acercar la respuesta a información autorizada y actualizada, pero no garantiza que los fragmentos sean pertinentes ni que la respuesta sea correcta. Por eso importan las fuentes, sus versiones y las citas.

## 3. Un agente que puede actuar

Circo Bus utiliza un agente para organizar inspecciones y tareas de mantenimiento de las unidades. El agente puede consultar y modificar turnos. Un reporte subido a la plataforma contiene una instrucción falsa para borrar registros de mantenimiento y cancelar todas las inspecciones.

### Agente, herramientas y ReAct

Un **agente** recibe un objetivo y puede decidir qué pasos seguir. Una **herramienta** (*tool*) es una función externa que puede invocar; por ejemplo, consultar o modificar un turno.

**ReAct** es un patrón que alterna pasos de razonamiento con acciones en herramientas y observaciones de sus resultados. El agente propone una acción y luego recibe información de lo que ocurrió. Este patrón organiza la interacción, pero no autoriza por sí mismo una acción.

La instrucción del reporte es un ejemplo de **inyección de prompts** (*prompt injection*): contenido procesado por el modelo intenta desviarlo de su propósito. El texto de un archivo puede aportar información, pero no tiene autoridad para cambiar permisos ni reglas de la aplicación.

### Supervisión humana antes de una acción

**Human-in-the-Loop (HITL)** incorpora a una persona en un punto definido del flujo para revisar, corregir, aprobar o detener una propuesta. Antes de cancelar inspecciones, la plataforma pausa y presenta el pedido original, la fuente consultada, la herramienta, el alcance y las consecuencias.

Una aprobación corresponde a una acción concreta. Si cambia el alcance —por ejemplo, de una inspección a todos los turnos— la persona debe revisar la nueva propuesta. El rechazo o la falta de respuesta dejan la acción sin ejecutar. La aprobación tampoco reemplaza los **permisos**, las validaciones ni otros controles técnicos de la plataforma.

### Trazabilidad y gestión responsable

La **trazabilidad** permite reconstruir qué ocurrió: quién solicitó una acción, qué herramienta se propuso, qué decisión se tomó y cuál fue el resultado. Un **registro de auditoría** guarda esa información en campos estructurados; **JSON** es un formato de texto común para organizar esos campos.

**ISO/IEC 42001:2023** es una norma internacional con requisitos para establecer, mantener y mejorar un sistema de gestión de inteligencia artificial en una organización. La organización define responsabilidades, riesgos y controles durante el ciclo de vida. Un registro aporta evidencia para revisar un evento; por sí solo no prueba que la decisión fue correcta ni que se cumple la norma.

## Cómo se conectan los temas

El modelo estima la cantidad de pasajeros con datos y métricas; el asistente usa RAG para consultar políticas y memoria para seguir la conversación; el agente conecta una recomendación con herramientas. Cuando una acción puede afectar el servicio o a otras personas, los permisos técnicos, la revisión humana y la trazabilidad trabajan juntos.

## Fuentes para ampliar

- [ISO/IEC 42001:2023 — sistemas de gestión de IA](https://www.iso.org/standard/81230.html)
- [ReAct: razonamiento y acción en modelos de lenguaje](https://arxiv.org/abs/2210.03629)
- [RAG: generación con recuperación de información](https://arxiv.org/abs/2005.11401)
- [OWASP — inyección de prompts](https://genai.owasp.org/llmrisk/llm01-prompt-injection/)

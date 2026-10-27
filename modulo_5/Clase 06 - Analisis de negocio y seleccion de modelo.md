# Clase 6 — Del análisis de datos a una propuesta de negocio: interpretar y defender

**Duración:** 90 minutos. **Modalidad:** continuación del trabajo en los mismos dos grupos, con Python e inteligencia artificial.

Partimos del notebook y la pregunta de negocio de la [Clase 5](<Clase 5 - Analisis exploratorio de datos de credito.md>). Seguimos usando [dataset_credito.csv](../modulo_3/dataset_credito.csv). Hoy profundizamos la evidencia, proponemos una acción y justificamos qué modelo podría aportar valor. **No se exige entrenar un modelo.**

## Objetivo y organización

El objetivo es conectar los hallazgos con una decisión de negocio y defender una propuesta que reconozca sus límites. La selección de un modelo debe responder a esa decisión y a los datos disponibles.

| Momento | Tiempo | Resultado |
|---|---:|---|
| Explicación conceptual | 15 min | Conectar problema, indicadores y modelo |
| Trabajo de los grupos | 45 min | Profundizar y preparar la defensa |
| Defensas y preguntas | 25 min | 8 minutos de exposición y 4 de preguntas por grupo, más 1 de transición |
| Cierre comparativo | 5 min | Contrastar propuestas y límites |

## 1. De los hallazgos a una decisión — 15 minutos

### Definir el problema de negocio

El análisis exploratorio pregunta qué muestran los datos. El análisis de negocio pregunta para qué sirve esa evidencia, quién la usaría y qué decisión podría mejorar.

Por ejemplo, una diferencia de morosidad entre productos puede motivar una revisión de sus características o del proceso de seguimiento. No demuestra por sí sola que el producto cause la morosidad ni que retirarlo mejore el negocio.

Definí el problema con tres elementos: **quién necesita decidir, qué decisión enfrenta y qué resultado busca mejorar**. Si los datos no alcanzan, delimitá qué parte del problema sí permiten estudiar.

### Elegir indicadores

Un **indicador** es una medida que permite describir o seguir un aspecto del problema. Debe tener una definición, una población y una forma de cálculo claras.

La proporción de registros morosos, por ejemplo, requiere indicar qué filas se incluyen y cuál es el denominador. Compará proporciones junto con tamaños de grupo. Un resultado basado en pocos casos necesita una interpretación más cautelosa.

No confundas volumen de crédito con rentabilidad. Para estimar rentabilidad o pérdidas pueden faltar tasas, costos, recuperaciones y horizonte temporal. Tampoco hables de evolución temporal si no hay fechas adecuadas para medirla.

### Separar observación, hipótesis y recomendación

| Nivel | Qué expresa |
|---|---|
| Hallazgo observado | Lo que una tabla, cálculo o gráfico permite afirmar |
| Hipótesis | Una explicación posible que todavía debe comprobarse |
| Recomendación | Una acción propuesta, con condiciones y evidencia necesaria |

La IA puede redactar una explicación convincente sin que los datos la respalden. Revisá cada afirmación y vinculala con una salida del notebook o identificála como hipótesis.

### Seleccionar un modelo por su utilidad

Un **modelo** utiliza patrones de datos para producir una estimación, clasificación o agrupamiento. Primero definí la tarea y después elegí la herramienta.

| Tarea | Qué busca | Alternativas que podrían compararse |
|---|---|---|
| Clasificación | Estimar una categoría, como moroso/no moroso | Regresión logística y árbol de decisión |
| Regresión | Estimar una cantidad numérica definida | Regresión lineal y árbol de regresión |
| Agrupamiento | Encontrar perfiles similares sin una etiqueta objetivo | K-means y agrupamiento jerárquico |

Son ejemplos, no opciones obligatorias. Para elegir, considerá el propósito, las variables disponibles, la interpretabilidad, la preparación necesaria y cómo evaluarías el resultado. Compará también con una **referencia sin modelo**, como una regla explícita o un informe descriptivo que apoye la misma decisión. Si esa referencia ya resuelve la necesidad, explicá qué valor adicional justificaría un modelo.

### Evaluar antes de prometer

Sin entrenar y evaluar, podemos justificar una elección y diseñar una evaluación; no afirmar que el modelo es preciso o útil.

En una predicción de morosidad, un **falso positivo** clasifica como moroso a quien no lo es; un **falso negativo** no identifica a quien sí lo es. Sus consecuencias dependen de la acción que se tome. La exactitud global no describe por sí sola esos errores. Podrían revisarse la matriz de confusión, la precisión de las alertas y la proporción de casos morosos detectados, junto con el impacto de negocio.

Para un modelo supervisado, proponé evaluar con datos separados de los usados para entrenar y preparar. Si corresponde predecir eventos futuros, harían falta fechas y una evaluación temporal. Para agrupamientos, explicá cómo revisarías la estabilidad, la interpretación y la utilidad de los grupos.

Definí **cuándo se haría la predicción**. Usar información que solo se conoce después del resultado produce una **fuga de información** y puede dar una impresión engañosa de desempeño. Si elegís predecir morosidad, revisá especialmente `dias_atraso`, `canti_moras`, las columnas de deuda y cualquier variable cuya fecha o definición no esté confirmada. No las aceptes automáticamente como predictoras ni supongas que todas son inválidas: justificá su disponibilidad en ese momento.

## 2. Ejercicio abierto: continuar el análisis — 45 minutos

> Retomen su análisis y elijan un problema de negocio respaldado por los datos. Profundicen la evidencia, propongan una acción y justifiquen qué modelo usarían para apoyar ese problema. Defiendan sus decisiones frente al otro grupo.

Los grupos mantienen su trabajo anterior. Pueden reformular la pregunta si los hallazgos lo justifican, dejando explicado el cambio. Cada grupo elige su enfoque; ambos cumplen las mismas exigencias.

### Pasos obligatorios

1. Definí el problema, quién usaría el resultado y qué decisión ayudaría a tomar.
2. Elegí indicadores y realizá las comparaciones adicionales necesarias en Python.
3. Separá hallazgos observados, hipótesis y recomendaciones.
4. Prepará una recomendación, sus límites y los datos adicionales necesarios para validarla.


### Cómo apoyarse en la IA

Compartí preguntas, definiciones y resultados verificados. Pedile que critique la propuesta, señale supuestos y compare alternativas, además de ayudarte con código y redacción. Un pedido posible:

> Nuestro problema de negocio es [problema] y estos son nuestros hallazgos comprobados: [evidencia]. La decisión que queremos apoyar es [decisión]. Ayudanos a comparar dos modelos adecuados y una referencia sin modelo. Explicá los datos necesarios, posibles fugas de información y cómo evaluaríamos la utilidad. Separá hechos, hipótesis y recomendaciones. No atribuyas rendimiento a modelos que no entrenamos.

El grupo debe poder defender la elección con sus propias palabras. Conservá un ejemplo de revisión de una sugerencia de IA de esta clase.

### Entrega

Entregá el notebook actualizado, ejecutable desde el inicio, conservando las decisiones y verificaciones de la Clase 5. Agregá el análisis de negocio, la comparación de alternativas y el diseño de evaluación como texto; no hace falta código de entrenamiento.

Prepará una presentación de **hasta cinco diapositivas**:

1. **Problema:** quién decide, qué necesita y qué pregunta abordaron.
2. **Evidencia:** indicadores, comparaciones y hallazgos respaldados.
3. **Propuesta:** acción recomendada y qué necesita validarse.
4. **Modelo elegido:** alternativas, referencia sin modelo y evaluación prevista.
5. **Límites:** supuestos, riesgos de interpretación y datos faltantes.

## 3. Defensa y cierre — 30 minutos

Cada grupo dispone de 8 minutos para exponer y 4 para responder preguntas del otro grupo y del docente. Hay 1 minuto de transición entre las dos defensas.

Preguntas para la discusión:

- ¿Qué resultado concreto respalda la recomendación?
- ¿Qué cambiaría si el grupo comparado tuviera pocos registros o faltantes relevantes?
- ¿Por qué el modelo elegido aportaría más que la referencia sin modelo?
- ¿Qué variables estarían disponibles cuando se lo use?
- ¿Qué resultado de una evaluación les haría revisar la propuesta?

En los últimos 5 minutos, compararemos cómo el mismo dataset permitió enfoques distintos y qué evidencia adicional necesita cada propuesta.

## Criterios de evaluación

- **Trazabilidad y verificación:** las afirmaciones se pueden seguir hasta los cálculos del notebook.
- **Coherencia de negocio:** problema, indicadores y recomendación están conectados.
- **Selección del modelo:** tarea, alternativas, referencia y evaluación están justificadas.
- **Defensa y límites:** el grupo responde preguntas, reconoce incertidumbre y explica la revisión de IA.

No se afirmarán causas, rentabilidad ni capacidad predictiva sin evidencia suficiente. La entrega es una propuesta de análisis y evaluación, no una política de aprobación automática de créditos.

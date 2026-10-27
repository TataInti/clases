# Clase 5 — Del análisis de datos a una propuesta de negocio: explorar y comprender

**Duración:** 90 minutos. **Modalidad:** ejercicio abierto en dos grupos, con Python e inteligencia artificial.

Esta clase y la [Clase 6](<Clase 6 - Analisis de negocio y seleccion de modelo.md>) forman un único trabajo. Hoy construimos la evidencia desde la ciencia de datos y hacemos una primera lectura de negocio. En la siguiente clase retomaremos el análisis para proponer una acción y justificar un modelo.

## Objetivo y material

El objetivo es realizar un **análisis exploratorio de datos**: examinar la estructura, la calidad, las distribuciones y las relaciones de un conjunto de datos para entender qué podemos afirmar y qué necesitamos investigar.

Usaremos [dataset_credito.csv](../modulo_3/dataset_credito.csv), con 1.190 registros y 26 columnas. El material previo describe cada fila como una solicitud de crédito y define `moroso` como `0` (no moroso) o `1` (moroso). El CSV, por sí solo, no confirma el origen, el período, la unidad monetaria ni el momento en que se registraron las variables. Esas limitaciones deben quedar documentadas.

Entre sus columnas están `ingresos`, `edad`, `Cuota`, `Monto_Otorgado`, `PRODUCTO`, `PROVINCIA`, `dias_atraso` y `moroso`. No deduzcas el significado exacto de una variable solo por su nombre: registrá qué conocés y qué falta confirmar.

Pandas permite trabajar con la tabla como un **DataFrame**, una estructura de filas y columnas. Python hará los cálculos y gráficos; la IA puede proponer un recorrido, escribir código y ayudar a interpretarlo. El grupo debe revisar y comprobar lo que acepta.

## Organización de la clase

| Momento | Tiempo | Resultado |
|---|---:|---|
| Explicación conceptual | 20 min | Comprender el recorrido básico |
| Trabajo abierto en dos grupos | 50 min | Notebook con análisis y verificaciones |
| Presentaciones | 15 min | 7 minutos por grupo y 1 de transición |
| Cierre | 5 min | Una pregunta de negocio para continuar |

## 1. El recorrido básico de un análisis — 20 minutos

### Formular una pregunta

Una pregunta de análisis indica qué queremos conocer y qué evidencia necesitamos. “Analizá todo” no orienta el trabajo. “¿Cómo se distribuye la morosidad entre los productos registrados?” permite identificar variables, comparaciones y límites.

Las preguntas pueden cambiar al explorar, pero hay que explicar por qué. En esta clase buscamos describir y comprender; una diferencia entre grupos no demuestra qué la causó.

### Comprender los datos

Antes de calcular, identificá qué representa una fila, qué mide cada columna y qué valores puede tomar. Diferenciá variables numéricas de categorías. Un código numérico de provincia representa una categoría: su promedio no tiene una interpretación útil.

Anotá también qué población está representada y qué información desconocemos. Los registros disponibles no necesariamente describen a todas las personas que solicitan crédito.

### Revisar la calidad y preparar

Revisá tipos de datos, valores faltantes, duplicados y valores atípicos. Un **valor atípico** es una observación que se aleja del comportamiento habitual; puede ser un error o un caso válido. Un faltante no equivale a cero y dos filas parecidas no necesariamente son duplicados.

La preparación debe responder a un problema concreto. Antes de eliminar, completar o transformar, explicá el criterio y su efecto sobre el análisis. Conservá el CSV original y trabajá sobre una copia de la tabla. Si una columna necesita una definición para poder usarse, dejala pendiente o explicitá el supuesto.

### Explorar y visualizar

Una **distribución** muestra cómo se reparten los valores. El promedio resume un conjunto, pero puede cambiar mucho por valores extremos; la mediana es el valor central al ordenar las observaciones. Conviene acompañar estas medidas con la cantidad de casos y una descripción de su variación.

Explorá primero variables individuales y después relaciones entre ellas. Usá barras para comparar categorías, histogramas para distribuciones numéricas y dispersión para observar dos variables numéricas. Cada gráfico debe tener una pregunta, título, ejes y unidades conocidas; si una unidad no está confirmada, señalalo.

Al comparar morosidad, distinguí **cantidad de casos morosos** de **proporción de morosos dentro de cada grupo**. Un producto con más registros puede tener más casos morosos sin tener una proporción mayor.

### Validar y comunicar

Comprobá totales antes y después de preparar, revisá algunas filas y contrastá un cálculo sencillo. Explicitá el denominador de cada porcentaje y cómo trataste los faltantes. Ejecutar una celda sin errores no garantiza que el cálculo responda la pregunta.

Un hallazgo combina una afirmación y su evidencia. La primera interpretación de negocio agrega por qué podría importar. Por ejemplo, una diferencia observada puede justificar investigar un segmento, pero todavía no justificar cambiar una política de crédito.

## 2. Ejercicio abierto en dos grupos — 50 minutos

> Formen dos grupos. Analicen el dataset de crédito con Python y apoyo de inteligencia artificial. Cada grupo elegirá sus preguntas y su camino de exploración, pero deberá documentar todos los pasos básicos y comprobar los resultados antes de presentarlos.

Ambos grupos reciben el mismo archivo y tienen las mismas exigencias. No hay una solución única ni preguntas asignadas por grupo. Pueden organizarse libremente, pero todos deben poder explicar las decisiones y los resultados.

### Pasos obligatorios

1. Formulá las preguntas que orientarán el análisis.
2. Describí los registros y las variables elegidas; anotá definiciones y contexto pendientes.
3. Revisá tipos, faltantes, duplicados y valores atípicos.
4. Justificá la preparación y registrá cuántas observaciones afecta. Si no hace falta modificar algo, fundamentalo.
5. Explorá distribuciones y relaciones con estadísticas y gráficos pertinentes.
6. Verificá recuentos, cálculos y coherencia entre tablas, gráficos y conclusiones.
7. Escribí tres hallazgos respaldados, sus límites y una primera implicación de negocio.

Como referencia para administrar el tiempo: 10 minutos para preguntas y comprensión, 10 para calidad y preparación, 20 para exploración y 10 para verificaciones y entrega. Pueden ajustar esa distribución según lo que encuentren.

### Cómo apoyarse en la IA

Pedí primero una propuesta de pasos y después código para una tarea acotada. Leé el código antes de ejecutarlo y revisá los resultados antes de pedir conclusiones. Podés usar este pedido como punto de partida y adaptarlo a tus preguntas:

> Estamos analizando un dataset de crédito con Python. Nuestra pregunta es [pregunta] y estas son las columnas y definiciones que conocemos: [detalle]. Proponé un recorrido exploratorio y las verificaciones necesarias. Señalá qué información falta confirmar. No inventes resultados ni definiciones y esperá nuestra revisión antes de escribir el código.

La IA debe interpretar salidas reales del notebook. Guardá un ejemplo concreto de una sugerencia que el grupo comprobó, corrigió o descartó y explicá el motivo.

### Entrega

Un notebook que pueda ejecutarse desde el inicio, con la ruta de carga documentada, las decisiones de preparación, las salidas y las conclusiones. Si lo guardás en `modulo_5/` y lo ejecutás desde esa carpeta, la ruta relativa al CSV será `../modulo_3/dataset_credito.csv`.

El notebook debe cerrar con:

| Elemento | Qué debe incluir |
|---|---|
| Tres hallazgos | Afirmación, tabla o gráfico que la respalda y límite |
| Primera lectura de negocio | Por qué un hallazgo podría importar |
| Pregunta para la Clase 6 | Qué decisión o problema conviene profundizar |
| Uso de IA | Una sugerencia revisada y cómo se comprobó |

## 3. Presentación y cierre — 20 minutos

Cada grupo tiene 7 minutos para explicar su pregunta, una decisión de preparación, los tres hallazgos y la pregunta que continuará. Reservamos 1 minuto para la transición.

En los últimos 5 minutos, compararemos los enfoques: ¿coincidieron los hallazgos?, ¿cambiaron los resultados por el tratamiento de los datos?, ¿qué conclusión necesita más evidencia? Cada grupo dejará elegida su pregunta de negocio y conservará el notebook para la Clase 6.

## Criterios de evaluación

- **Trazabilidad:** se entiende cómo se pasó de los datos originales a los resultados.
- **Calidad y verificación:** las decisiones están justificadas y los cálculos comprobados.
- **Interpretación:** los hallazgos responden las preguntas y reconocen los límites.
- **Revisión de IA:** el grupo puede explicar y defender lo que aceptó.

La cantidad de gráficos o la extensión del código no sustituyen un análisis claro y verificable.

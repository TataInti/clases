# Clase 7 — Evaluar y optimizar un modelo

**Duración:** 90 minutos. **Modalidad:** dos grupos, con Python y TensorFlow/Keras.

En las clases 5 y 6 exploramos los datos de crédito y propusimos una decisión de negocio. En esta clase practicamos cómo entrenar y evaluar un modelo y probar un ajuste sencillo.

## Caso de trabajo

Una entidad quiere priorizar qué clientes podrían recibir un contacto preventivo para recordarles sus cuotas y ofrecerles orientación. El modelo solo ordenaría casos para que una persona los revise; no aprobaría ni rechazaría créditos.

Usaremos [dataset_credito.csv](dataset_credito.csv). Para este ejercicio, la etiqueta a estimar es `moroso` y se consideran como predictoras de base `ingresos`, `Cuota`, `Monto_Otorgado` y `PRODUCTO`. 

**Ustedes pueden ampliar** las predictoras, pero cuidado, no incluyan información que podría revelar el resultado de la etiqueta en el momento de la predicción (data leakage).

## Qué vamos a aprender

- Reservar datos de prueba y no usarlos para elegir el modelo.
- Comparar dos configuraciones con validación cruzada.
- Interpretar recall, precisión, F1 y la matriz de confusión.
- Explicar qué mejoró y qué límite sigue teniendo el resultado.

## Recorrido de la clase

| Momento | Tiempo | Trabajo |
|---|---:|---|
| Abrir Colab, leer el caso y acordar la métrica | 10 min | Preparar el notebook y definir qué error queremos reducir |
| Repasar evaluación y sobreajuste | 15 min | Entrenamiento, validación, prueba y métricas |
| Entrenar la configuración base | 25 min | Modelo Keras pequeño y revisión inicial |
| Comparar un ajuste | 20 min | Validación cruzada y prueba final |
| Preparar y dar las presentaciones | 15 min | Cinco pasos, cinco minutos por grupo |
| Cierre | 5 min | Un límite y un dato que falta |

## Notebook de entrega y entorno

Cada grupo completa su notebook de Colab:

- [Grupo 1](https://colab.research.google.com/drive/196Gnj38xgJvesQvqmV3kgenHPk8Y2ggl?usp=sharing)
- [Grupo 2](https://colab.research.google.com/drive/1BlwIrzODEPY4H00jCIhbZh3Z86TNg5qg?usp=sharing)

En Colab, conecten el entorno de ejecución, asegúrense de que `dataset_credito.csv` esté disponible y ejecuten primero las importaciones. Si falta una librería, instálenla en una celda inicial, por ejemplo: `%pip install -q scikit-learn`. TensorFlow, pandas y otras librerías pueden venir ya instaladas; no las reinstalen si las importaciones funcionan.

Para colaborar, compartan el notebook con los integrantes como **Editor** y trabajen en el mismo archivo. El documento se comparte, pero cada sesión de ejecución es independiente; coordinen quién ejecuta y revisa cada etapa. [Ayuda de Colab](https://research.google.com/colaboratory/faq.html) · [Permisos para compartir en Drive](https://support.google.com/drive/answer/7166529?hl=es).

## Ideas básicas

- Separamos los datos en **entrenamiento** y **prueba**. 
- El modelo aprende con los primeros; la prueba queda apartada hasta el final. 
- Para elegir entre configuraciones, usamos **validación cruzada** sobre el conjunto de entrenamiento: repetimos la evaluación en tres particiones y comparamos el promedio.
- La clase positiva es `moroso = 1`. 

**Metricas de evaluacion:**
- Para este caso elegimos **`recall`** como métrica principal: queremos encontrar la mayor cantidad posible de casos que aparecen como morosos en la etiqueta. 
- También miramos **`precisión`** para saber cuántos casos señalados corresponden a esa clase y **`F1`** para resumir ambas medidas. La matriz de confusión permite ver falsos positivos y falsos negativos.


## Actividad guiada en los dos grupos

>**Objetivo**: Entrenar un modelo usando Keras/TensorFlow y comparar dos configuraciones.

Con ayuda de la IA construyen un modelo pequeño con una capa oculta y comparan:

- **Configuración base:** 8 neuronas en la capa oculta.
- **Configuración ajustada:** 16 neuronas en la capa oculta.
- **Variables predictoras nuevas**

Usamos un solo notebook para todos los experimentos. Vamos agregando celdas para cada etapa. Mantener simple todo el proceso.

**Consignas**:
- Mantengan por defecto las opciones del modelo. 
- Usen una `división estratificada` de 80 % para entrenamiento y 20 % para prueba. 
- Incorporen Cross-Validation
- Elijan la configuración con el mayor `recall promedio` en validación cruzada. Si los promedios son parecidos, quédense con la más sencilla. 
- Registren también `precisión` y `F1`; no hace falta probar otros modelos ni ajustar más parámetros.

## Presentación: cinco pasos

Cada grupo tiene 7 minutos y sigue este orden. Pueden preparar una diapositiva por paso y repartir la explicación entre sus integrantes.

1. **Caso:** ¿qué intenta priorizar el modelo y qué acción humana podría seguir?
2. **Datos:** ¿cuál es la etiqueta, qué predictoras usaron y qué supuesto hicieron sobre su disponibilidad?
3. **Evaluación:** ¿cómo separaron entrenamiento y prueba, y cómo aseguraron que no haya data leakage?
4. **Resultados:** muestren recall promedio en validación cruzada y, para la configuración elegida, la matriz de confusión, precisión, recall y F1 en la prueba.
5. **Decisión y límite:** ¿qué configuración eligen y qué información falta antes de interpretar el resultado fuera del ejercicio?


## Pedir ayuda a la IA, etapa por etapa

Pídanle que avance **una etapa por vez**, explique qué van a ejecutar y espere su revisión antes de seguir. No acepten métricas que no salgan al ejecutar el notebook.

1. **Preparar los datos:** “Ayudanos a preparar `dataset_credito.csv` para estimar `moroso` con `ingresos`, `Cuota`, `Monto_Otorgado` y `PRODUCTO`. Revisá tipos de datos y valores faltantes. Excluí columnas que puedan revelar información posterior. Explicá la celda antes de escribirla.”
2. **Crear la referencia base:** “Separá los datos en entrenamiento y prueba (80/20, estratificado). Prepará el preprocesamiento usando solo entrenamiento y armá un modelo pequeño con una capa oculta de 8 neuronas. Mostranos una tabla de parámetros, valores y cuáles quedan fijos antes de ejecutarlo.”
3. **Probar una mejora:** “Compará 8 y 16 neuronas con validación cruzada de 3 particiones, usando recall promedio. Cambiá solo `unidades_capa_oculta` (8 → 16); mantené iguales las demás opciones y ajustá el preprocesamiento dentro de cada partición, sin mirar la validación de esa partición. No uses el conjunto de prueba para elegir. Mostrá una tabla con configuración y resultado.”
4. **Evaluar y explicar:** “Con la configuración elegida por validación cruzada, entrená con todo el conjunto de entrenamiento y evaluá la prueba una sola vez. Mostrá matriz de confusión, precisión, recall y F1. Explicá qué significan usando solo los valores obtenidos.”

Antes de comparar, verifiquen que la IA haya identificado el parámetro que cambia (`unidades_capa_oculta`), sus dos valores (8 y 16) y las opciones que deja fijas. Si propone cambiar otra cosa, pídanle que la mantenga igual para esta práctica.

## Cierre

Después de las dos presentaciones, comparen qué configuración obtuvo mayor recall promedio y si ese orden se mantuvo en la prueba. Para terminar, cada grupo nombra un dato que habría que confirmar antes de usar datos reales.

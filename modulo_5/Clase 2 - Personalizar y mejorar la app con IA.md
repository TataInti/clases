# Clase 2 — Personalizar y mejorar la app con IA (Semana 1)

> **Formato:** Turno 2 de la Semana 1 (2 horas). Partimos de la app que ya funciona (Clase 1) y la hacemos **tuya**. Primero la personalizamos a mano y después aprendemos a **vibe coding**: darle instrucciones a una IA (Claude, ChatGPT, etc.) para que produzca y mejore software por nosotros.

## Objetivos de la clase

- Personalizar la app web (títulos, textos, estilo) sin romper nada.
- Entender qué es el **vibe coding** y cómo darle instrucciones a una IA.
- Usar una IA para **mejorar** la app con funciones nuevas.
- Revisar y decidir qué cambios quedan, manteniendo el criterio humano.

## Cómo usar esta guía (leela paso a paso)

Este documento es **tu guía de clase**: lo vas a leer de arriba hacia abajo y hacer lo que dice en orden. Cada sección te dice **qué hacer** y **qué esperar**. No saltees pasos: cada uno construye sobre el anterior.

### Convenciones que vas a encontrar

| Símbolo | Significado |
|---|---|
| ✏️ **Editar** | Tenés que modificar un archivo que ya creaste (`app.py`) |
| ▶️ **Ejecutar** | Tenés que correr algo y mirar el resultado |
| 💡 **Concepto** | Explicación teórica: leela y entendela, no hay que ejecutar nada |
| ✅ **Verificar** | Comprobación de que el paso anterior funcionó |

### Regla de oro de la guía

> **Un paso a la vez.** Después de cada paso, verificá que funcionó antes de seguir. Si algo falla, el error casi siempre está en el paso anterior.

---

## 1. Personalizar la app (ejercicio guiado)

La app ya funciona (Clase 1). Ahora la hacemos **tuya**. La app se recarga sola cada vez que guardás el archivo, así que vas a ver los cambios al instante.

### ✏️ Paso 1.1 — Cambiar el título

En `app.py`, buscá la línea `st.title("🤖 Chatbot del curso")` y cambiá el texto entre comillas por un título con tu nombre o el de tu proyecto:

```python
st.title("🤖 Mi asistente de IA")
```

### ✅ Verificar

Guardá (Ctrl+S) y mirá el navegador: el título grande debería cambiar al instante.

### ✏️ Paso 1.2 — Cambiar el subtítulo

Buscá la línea `st.caption(...)` y cambiá el texto:

```python
st.caption("Asistente personal de Inti")
```

### ✅ Verificar

El texto pequeño debajo del título debería cambiar.

### ✏️ Paso 1.3 — Cambiar el placeholder

Buscá la línea `st.chat_input("Escribí tu pregunta sobre el curso...")` y cambiá el texto:

```python
pregunta = st.chat_input("Preguntame lo que quieras...")
```

### ✅ Verificar

El texto gris dentro de la caja de chat debería cambiar.

### ✏️ Paso 1.4 — Cambiar el estilo de respuesta

Buscá el prompt dentro de `responder()` y cambiá la instrucción:

```python
prompt = f"Respondé como un tutor paciente y didáctico.\n\nPregunta: {pregunta}\n\nRespuesta:"
```

### ✅ Verificar

Enviá una pregunta nueva: la respuesta debería sonar más didáctica.

### ✏️ Paso 1.5 — Probar la temperatura

Buscá `temperature=0.7` y probá estos tres valores, uno a la vez:

| Valor | Efecto |
|---|---|
| `0.0` | Siempre la misma respuesta, más precisa pero rígida |
| `0.7` | Equilibrio entre precisión y naturalidad |
| `1.5` | Muy creativo, puede inventar más |

### ✅ Verificar

Enviá la misma pregunta con cada valor y compará las respuestas.

> **Regla de oro:** cada vez que cambies algo, preguntate *"¿qué espero que cambie en pantalla?"*. Si no cambia nada, revisá que guardaste el archivo.

---

## 2. Vibe coding: programar con ayuda de una IA

Hasta acá escribimos el código a mano, paso a paso. Pero en el mundo real, cada vez más se programa **con la ayuda de una IA** que escribe el código por nosotros. A eso se lo llama **vibe coding** ("programar por vibra"): vos le explicás a la IA **qué querés**, y ella te devuelve **el código**.

### 💡 Concepto: ¿qué es el vibe coding?

**Vibe coding** es la práctica de usar un asistente de IA (Claude, ChatGPT, GitHub Copilot, etc.) para generar, modificar y depurar código. En vez de escribir cada línea, **describís el resultado deseado** y la IA lo implementa.

| Rol | Quién lo hace |
|---|---|
| **Describir qué querés** | Vos (la persona) |
| **Escribir el código** | La IA |
| **Revisar y decidir** | Vos (la persona) |

> **La clave del vibe coding:** la IA no reemplaza tu criterio. Vos seguís siendo quien **decide qué es correcto**, qué se ve bien y qué funciona. La IA acelera, pero el criterio es tuyo. Por eso aprendimos las 3 capas y el frontend/backend: para poder **entender y revisar** lo que la IA produce.

### 💡 Concepto: cómo darle instrucciones a una IA

Para que una IA produzca buen código, hay que darle **buenas instrucciones** (prompts). Un buen prompt para programar tiene 4 ingredientes:

| Ingrediente | Pregunta que responde | Ejemplo |
|---|---|---|
| **Rol** | ¿Quién es la IA? | "Sos un experto en Streamlit" |
| **Contexto** | ¿Qué tenemos? | "Tengo una app de chat en `app.py`" |
| **Tarea** | ¿Qué querés que haga? | "Agregá un botón para borrar el historial" |
| **Restricciones** | ¿Cómo lo querés? | "En español, con comentarios, sin cambiar la capa de modelo" |

**La fórmula del prompt perfecto:**

```
[Rol] + [Contexto] + [Tarea] + [Restricciones]
```

> **Regla de oro del prompt:** sé específico. "Mejorá la app" es un mal prompt. "Agregá un botón que borre el historial de la conversación, en español, sin tocar la capa de modelo" es un buen prompt.

---

## 3. Mejorar la app con una IA (ejercicio guiado)

Ahora vamos a usar una IA (Claude, ChatGPT, etc.) para mejorar la app que acabamos de crear. El flujo es siempre el mismo:

1. **Copiá el código** de tu `app.py`.
2. **Pegalo** en el chat de la IA.
3. **Pedile** un cambio con un prompt bien armado.
4. **Revisá** el código que te devuelve.
5. **Pegalo** de vuelta en `app.py` y guardá.
6. **Probalo** en el navegador.

### ▶️ Paso 3.1 — Pedirle un cambio simple

Copiá tu `app.py` completo y pegáselo a la IA, seguido de este prompt:

```
Sos un experto en Streamlit. Tengo esta app de chat en Python.

[PEGÁ ACÁ EL CÓDIGO DE TU app.py]

Agregá un botón que borre el historial de la conversación.
Respondé en español, con comentarios, y no cambies la capa de modelo.
```

### ✅ Verificar

La IA te devuelve un `app.py` modificado. Reemplazá el contenido de tu archivo, guardá y probá en el navegador: debería aparecer un botón que limpia el chat.

### ▶️ Paso 3.2 — Pedirle un cambio visual

Ahora pedile que cambie la apariencia:

```
Ahora cambiá el estilo de la app para que se vea moderna:
- Un color de fondo suave.
- El título con un emoji distinto.
- Los mensajes del usuario en un color y los del asistente en otro.
Mantené toda la lógica igual.
```

### ✅ Verificar

La app debería verse distinta: fondo, colores y emoji nuevos. Si algo se rompe, pedile a la IA que lo corrija pegándole el error que aparece en la terminal.

### ▶️ Paso 3.3 — Pedirle una función nueva

Ahora algo más ambicioso: que la app **recuerde el nombre del usuario**:

```
Agregá una función para que la app pregunte el nombre del usuario
la primera vez y lo use para saludarlo en cada respuesta.
Guardá el nombre en st.session_state.
```

### ✅ Verificar

Al recargar la app, debería pedirte el nombre y usarlo en las respuestas.

> **Si algo falla:** copiá el mensaje de error de la terminal y pegáselo a la IA con la instrucción *"corregí este error"*. La IA suele arreglarlo sola. Eso también es vibe coding: **depurar con ayuda de la IA**.

---

## 4. Ejercicio de cierre

1. **Probalo:** hacé 3 preguntas sobre el curso. ¿Alguna respuesta es dudosa o inventada? Anotala.
2. **Personalizalo:** aplicá los 5 cambios del ejercicio de personalización (paso 1).
3. **Mejoralo con IA:** usá la IA para agregar una función que se te ocurra (ej. un botón de "limpiar", un saludo con nombre, un tema oscuro).
4. **Pensá en la arquitectura:** ¿en qué capa de `app.py` agregarías la búsqueda en los notebooks para que el chatbot responda con el contenido del curso? Escribí tu idea.

**Para la próxima clase:** traé la lista de preguntas dudosas que encontraste. Van a ser nuestro set de evaluación para medir si el RAG mejora las respuestas.

---

## Resumen de la Semana 1

| Clase | Qué lograste |
|---|---|
| Clase 1 | Entendiste cómo se arma un software, la arquitectura de 3 capas y tenés la **app web funcionando** en el navegador |
| Clase 2 | Personalizaste la app a mano y la **mejoraste con ayuda de una IA** (vibe coding) |

**En la Semana 2** vamos a hacer que el chatbot responda con el contenido real del curso: cargar los notebooks, trocearlos, convertirlos en embeddings y guardarlos en ChromaDB.
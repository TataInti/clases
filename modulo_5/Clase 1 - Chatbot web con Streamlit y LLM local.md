# Clase 1 — Chatbot web con Streamlit y LLM local (Semana 1)

> **Formato:** Turno 1 de la Semana 1 (2 horas). En esta clase armamos la app web desde cero y la probamos. La personalización y mejora con IA se hace en la **Clase 2**.

## Objetivos de la clase

- Entender cómo se arma un software, aunque sea un proyecto chico.
- Explicar la arquitectura de una app de IA en 3 capas.
- Configurar un LLM local con llama.cpp (reutilizando lo del Módulo 4).
- Construir una **app web con Streamlit** que responde preguntas.
- **Probar la app funcionando** en el navegador.

## Cómo usar esta guía (leela paso a paso)

Este documento es **tu guía de clase**: lo vas a leer de arriba hacia abajo y hacer lo que dice en orden. Cada sección te dice **qué hacer**, **qué archivo crear**, **qué nombre y extensión ponerle** y **qué hace ese archivo**. No saltees pasos: cada uno construye sobre el anterior.

### Convenciones que vas a encontrar

| Símbolo | Significado |
|---|---|
| 📁 **Crear archivo** | Tenés que crear un archivo nuevo. Te dice el nombre y la extensión |
| 🖥️ **Terminal** | Tenés que escribir un comando en la terminal |
| ✏️ **Editar** | Tenés que modificar un archivo que ya creaste |
| ▶️ **Ejecutar** | Tenés que correr un archivo o comando y mirar el resultado |
| 💡 **Concepto** | Explicación teórica: leela y entendela, no hay que ejecutar nada |
| ✅ **Verificar** | Comprobación de que el paso anterior funcionó |

### Regla de oro de la guía

> **Un paso a la vez.** Después de cada paso, verificá que funcionó antes de seguir. Si algo falla, el error casi siempre está en el paso anterior. No avances con errores sin resolver: anotalos y preguntá.

---

## 1. Cómo se arma un software (aunque sea chico)

Antes de escribir código, entendamos **qué es un proyecto de software**. Un programa no es "un archivo": es una **carpeta con archivos que se organizan y se comunican**. Para un proyecto chico como el nuestro, alcanza con entender 4 piezas:

```
modulo_5/                      ← la carpeta del proyecto
├── Clase 1 - ...md            ← este archivo (la guía de la clase)
├── app.py                     ← el programa principal (la app web)
├── requirements.txt           ← la lista de dependencias
└── datos/                     ← (en la Semana 2) la base de conocimiento
```

| Pieza | Qué es | Analogía |
|---|---|---|
| Carpeta del proyecto | El contenedor de todo | La casa donde vive el software |
| Guía de la clase | Las instrucciones | El manual de la casa |
| `app.py` | El programa que se ejecuta | La cocina que sirve el plato final |
| `requirements.txt` | Las dependencias | La lista de ingredientes |

**Dos reglas de oro del software:**

1. **Separar responsabilidades.** Cada archivo hace una cosa. Si mezclás todo, un cambio rompe todo.
2. **El código se comenta para quien lo va a mantener.** Un programa se lee muchas más veces de las que se escribe. Los comentarios no son para la máquina: son para la persona (o vos mismo en 3 meses) que tiene que cambiar algo.

> En esta clase vamos a escribir el código **con muchos comentarios** que te dicen exactamente qué hace cada parte y cómo cambiarla.

### 💡 Concepto: frontend y backend

Cuando hablamos de una aplicación web, casi siempre la dividimos en dos grandes partes. Son los dos lados de cualquier programa que se usa por internet:

| Parte | Qué es | Analogía | En nuestro proyecto |
|---|---|---|---|
| **Frontend** | Lo que el usuario **ve y toca**: botones, cajas de texto, colores, la pantalla | El mostrador del restaurante, donde el cliente pide | La parte de Streamlit (título, chat, botón) |
| **Backend** | Lo que **procesa por detrás**: la lógica, los datos, el modelo | La cocina, donde se prepara el plato | La función `responder()` y el LLM |

- **Frontend** ("frente"): todo lo que ocurre en el navegador del usuario. Es la **capa de interfaz**.
- **Backend** ("detrás"): todo lo que ocurre en el servidor, invisible para el usuario. Es la **capa de lógica** y la **capa de modelo**.

> **La clave:** el usuario solo ve el frontend, pero el frontend no sirve de nada sin el backend. En nuestro chatbot, el usuario escribe en el frontend (Streamlit), y el backend (Python + LLM) piensa y devuelve la respuesta. Streamlit es especial porque **te deja escribir frontend y backend en un mismo archivo Python**, sin separarlos. Eso lo hace perfecto para aprender.

---

## 2. La arquitectura: una app de IA en 3 capas

Cualquier app de IA, por más compleja que sea, tiene la misma estructura de 3 capas:

```
┌─────────────────────────────────────────────┐
│  CAPA 1 · INTERFAZ (lo que ve el usuario)   │
│  Streamlit: caja de chat, botón, historial  │
└─────────────────────────────────────────────┘
                    │ pregunta
                    ▼
┌─────────────────────────────────────────────┐
│  CAPA 2 · LÓGICA (el cerebro de la app)     │
│  Recibe la pregunta, decide qué hacer       │
└─────────────────────────────────────────────┘
                    │ prompt
                    ▼
┌─────────────────────────────────────────────┐
│  CAPA 3 · MODELO (el que redacta)           │
│  LLM local con llama.cpp                    │
└─────────────────────────────────────────────┘
```

| Capa | Rol | En esta clase |
|---|---|---|
| Interfaz | Mostrar y capturar | Streamlit con chat |
| Lógica | Orquestar | Función `responder()` |
| Modelo | Generar texto | LLM local llama.cpp |

> **Por qué separar las capas:** hoy la lógica es trivial (mandar el prompt y devolver). En la Semana 2 le vamos a sumar la recuperación RAG. Si todo estuviera mezclado, ese cambio rompería la interfaz. Separar capas es lo que hace que el proyecto crezca sin dolor.

### 💡 Concepto: ¿qué hace Streamlit?

**Streamlit es una librería de Python que convierte un script en una app web.** Escribís código Python normal y Streamlit se encarga de dibujar la interfaz en el navegador. No necesitás saber HTML, CSS ni JavaScript.

Cada función de Streamlit dibuja un elemento en la página:

| Función de Streamlit | Qué dibuja en la página |
|---|---|
| `st.title("...")` | Un título grande |
| `st.caption("...")` | Un subtítulo pequeño |
| `st.chat_message("user")` | Una burbuja de chat (como WhatsApp) |
| `st.chat_input("...")` | La caja donde el usuario escribe |
| `st.spinner("...")` | Un indicador de "pensando..." |
| `st.session_state` | La "memoria" de la app entre mensajes |

> **La magia de Streamlit:** cuando editás el archivo y lo guardás, la app **se recarga sola** en el navegador. No tenés que reiniciar nada. Eso hace que experimentar sea rapidísimo: cambiás un texto, guardás, y lo ves al instante.

**¿Por qué usamos Streamlit y no otra cosa?** Porque es la forma más rápida de pasar de "tengo una función Python" a "tengo una app web". En la Semana 2, cuando agreguemos RAG, solo vamos a tocar la capa de lógica; la interfaz de Streamlit va a quedar casi igual.

---

## 3. Verificar las dependencias

El entorno ya tiene instaladas las tres librerías que necesitamos: `streamlit` para la web, `llama-cpp-python` para el LLM local y `huggingface-hub` para descargar el modelo.

### 🖥️ Paso 3.1 — Verificar que estén listas

Abrí la terminal y ejecutá:

```bash
python -c "import streamlit, llama_cpp, huggingface_hub; print('Todo instalado OK')"
```

### ✅ Verificar

Si ves `Todo instalado OK`, las dependencias están listas y podés seguir. Si ves un error, avisá al docente antes de continuar.

> **¿Qué son estas librerías?** Son la "lista de ingredientes" del proyecto. En un proyecto real se guardan en un archivo `requirements.txt` para que cualquiera pueda instalarlas con `pip install -r requirements.txt`. Acá ya están instaladas, pero es bueno saber de dónde vienen.

---

## 4. El LLM local (concepto)

En el Módulo 4 usamos `LFM2.5-1.2B-Instruct` con llama.cpp. Reutilizamos exactamente ese patrón: una función que recibe un prompt y devuelve texto. El resto de la app **nunca toca detalles de llama.cpp**.

> La primera ejecución descarga el modelo (~1,25 GB). Después reutiliza la caché.

### 💡 Concepto: ¿qué es un LLM local?

Un **LLM local** es un modelo de lenguaje que corre **en tu propia máquina**, sin internet ni API key. En el Módulo 4 ya lo usaste con llama.cpp. La ventaja es que es gratis, privado y no depende de un servicio externo.

En esta clase no creamos un archivo de prueba separado: **la carga del modelo va directamente dentro de `app.py`**. Así vamos directo a la aplicación, que es el objetivo de la clase.

---

## 5. Crear la app web

Ahora sí, lo importante: creamos la **app web completa**. Este archivo junta las 3 capas en un solo programa: carga el modelo (capa 3), define la lógica `responder()` (capa 2) y dibuja la interfaz con Streamlit (capa 1).

### 📁 Paso 5.1 — Crear `app.py`

Creá un archivo nuevo llamado **`app.py`** (extensión `.py`). Este es **el programa principal** del proyecto: la app web que el usuario va a usar. Se llama `app` porque es la aplicación.

> **¿Qué hace este archivo?** Cuando lo corras, se abre una página web en tu navegador con un chatbot que responde preguntas usando el LLM local.

Pegá dentro este código completo. **Leelo con atención: cada bloque tiene comentarios que te dicen qué hace y cómo cambiarlo.**

```python
# ============================================================
#  app.py — CHATBOT DEL CURSO
#  App web con Streamlit + LLM local (llama.cpp)
#
#  CÓMO CORRERLA:
#      streamlit run app.py
#  Se abre el navegador en http://localhost:8501
#
#  ESTRUCTURA (3 capas):
#      CAPA 1 · INTERFAZ  → Streamlit (lo que ve el usuario)
#      CAPA 2 · LÓGICA    → responder() (el cerebro)
#      CAPA 3 · MODELO    → LLM local (el que redacta)
# ============================================================

import streamlit as st
from llama_cpp import Llama
from huggingface_hub import hf_hub_download


# ============================================================
#  CAPA 3 · MODELO
# ============================================================
@st.cache_resource
def cargar_modelo():
    """Carga el LLM local UNA SOLA VEZ y lo reutiliza.

    @st.cache_resource hace que Streamlit no recargue el modelo
    en cada mensaje (cargar un LLM es lento). Sin esto, la app
    tardaría muchísimo en cada respuesta.

    PARA CAMBIAR EL MODELO:
        Cambiá 'repo_id' y 'filename' por otro modelo GGUF.
    """
    ruta = hf_hub_download(
        repo_id="unsloth/LFM2.5-1.2B-Instruct-GGUF",   # ← CAMBIAR: el modelo
        filename="LFM2.5-1.2B-Instruct-Q4_0.gguf",     # ← CAMBIAR: el archivo
    )
    return Llama(model_path=ruta, n_ctx=2048, n_gpu_layers=0, verbose=False)


# Cargamos el modelo una vez al arrancar la app
llm = cargar_modelo()


# ============================================================
#  CAPA 2 · LÓGICA
# ============================================================
def responder(pregunta: str, max_tokens: int = 200) -> str:
    """Convierte una pregunta en una respuesta usando el LLM.

    Esta es la función que en la Semana 2 va a buscar evidencia
    en la base de conocimiento ANTES de responder (RAG).
    """
    # El prompt le dice al modelo cómo comportarse.
    # PARA CAMBIAR EL ESTILO: editá el texto entre comillas.
    prompt = f"Respondé en español, de forma breve y clara.\n\nPregunta: {pregunta}\n\nRespuesta:"
    # temperature: 0.0 = siempre igual · 1.5 = muy creativo
    salida = llm(prompt, max_tokens=max_tokens, temperature=0.7)
    return salida["choices"][0]["text"].strip()


# ============================================================
#  CAPA 1 · INTERFAZ
# ============================================================
# Configuración de la pestaña del navegador.
# PARA CAMBIAR EL TÍTULO DE LA PESTAÑA: editá page_title.
# PARA CAMBIAR EL ÍCONO: editá page_icon (emojis o "🤖").
st.set_page_config(page_title="Chatbot del curso", page_icon="🤖")

# Título grande de la app.
# PARA CAMBIAR EL TÍTULO: editá el texto entre comillas.
st.title("🤖 Chatbot del curso")

# Subtítulo pequeño debajo del título.
# PARA CAMBIAR EL SUBTÍTULO: editá el texto entre comillas.
st.caption("Semana 1: responde sin contexto. En la Semana 2 aprende RAG.")

# ---- Historial de la conversación ----
# st.session_state guarda datos entre interacciones.
# Sin esto, cada mensaje borraría el anterior.
if "mensajes" not in st.session_state:
    st.session_state.mensajes = []

# Mostramos los mensajes ya guardados en el historial.
for rol, texto in st.session_state.mensajes:
    with st.chat_message(rol):   # rol = "user" o "assistant"
        st.write(texto)

# ---- Caja de entrada del chat ----
# PARA CAMBIAR EL TEXTO DEL PLACEHOLDER: editá el texto entre comillas.
pregunta = st.chat_input("Escribí tu pregunta sobre el curso...")

if pregunta:
    # 1) Guardamos la pregunta del usuario en el historial
    st.session_state.mensajes.append(("user", pregunta))
    # 2) La mostramos en pantalla
    with st.chat_message("user"):
        st.write(pregunta)
    # 3) Generamos la respuesta (con un spinner de "Pensando...")
    with st.chat_message("assistant"):
        with st.spinner("Pensando..."):
            respuesta = responder(pregunta)
        st.write(respuesta)
    # 4) Guardamos la respuesta en el historial
    st.session_state.mensajes.append(("assistant", respuesta))
```

### Leamos las decisiones

- **`@st.cache_resource`**: hace que el modelo se cargue **una sola vez** y se reutilice entre recargas de la página. Cargar un LLM es lento; no queremos repetirlo en cada mensaje.
- **`st.session_state`**: guarda el historial de la conversación entre interacciones. Sin esto, cada mensaje borraría el anterior.
- **Las 3 capas**: interfaz arriba, lógica en el medio, modelo abajo. Es el mismo diagrama del paso 2.

---

## 6. Correr la app

### ▶️ Paso 6.1 — Ejecutar la app

En la terminal, dentro de la carpeta del proyecto, ejecutá:

```bash
streamlit run app.py
```

> **¿Qué hace este comando?** Arranca un servidor web local y abre la app en tu navegador. El comando `streamlit` es el que instalamos con `requirements.txt`; `run app.py` le dice qué programa ejecutar.

### ✅ Verificar

Debería abrirse el navegador en `http://localhost:8501` con el título **"🤖 Chatbot del curso"** y una caja de chat. Si no se abre solo, copiá esa dirección en el navegador.

> **Importante:** dejá la terminal abierta mientras usás la app. Si cerrás la terminal, la app se apaga. Para detenerla, presioná `Ctrl+C` en la terminal.

---

## 7. Probar la app

Con la app corriendo (paso 6), probá preguntas como:

- *¿Qué es overfitting?*
- *¿Cómo se calcula la precisión?*
- *¿Qué es un sesgo?*

> **Observación clave:** el modelo responde desde su conocimiento general. Puede inventar o responder mal. Ese es exactamente el problema que vamos a resolver en la **Semana 2** con RAG: que responda usando **tus** notebooks como fuente.

---

## Resumen de la Clase 1

| Qué lograste |
|---|
| Entendiste cómo se arma un software y la arquitectura de 3 capas |
| Tenés una **app web funcionando** en el navegador que responde preguntas |

**En la Clase 2** vas a personalizar la app y aprender a mejorarla con ayuda de una IA (vibe coding). **En la Semana 2** vamos a hacer que el chatbot responda con el contenido real del curso (RAG).
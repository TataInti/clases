# Clase 3 — RAG con PDF: el asistente del Circo Aurora lee un documento

> **Formato:** Turno 1 de la Semana 2 (2 horas). Partimos del chatbot funcional de las Clases 1 y 2 y le enseñamos a responder usando un **documento PDF** como fuente de verdad, en lugar de su conocimiento general.

## Pregunta central de la clase

> ¿Cómo podemos hacer que nuestro chatbot responda con información real de un documento PDF, sin inventar datos, y de una manera que podamos comprobar?

## Objetivos de la clase

- Entender qué es un sistema **RAG** (Retrieval-Augmented Generation) y sus tres etapas.
- Extraer texto de un PDF con `pypdf`.
- Trocear el documento en fragmentos recuperables.
- Convertir texto en **embeddings** con `sentence-transformers`.
- Recuperar los fragmentos más relevantes ante una pregunta.
- Inyectar la evidencia en el prompt para que el modelo responda con fundamento.
- Mantener el ciclo de trabajo: un cambio por vez, probar y conservar o deshacer.

## Producto final

Al terminar la clase, nuestro chatbot:

- lee un PDF (`circo_aurora.pdf`) como base de conocimiento;
- ante una pregunta, busca los fragmentos más parecidos por significado;
- responde usando **solo** la evidencia recuperada;
- se niega a responder cuando no hay evidencia suficiente.

## Cómo usar esta guía

Esta clase es un laboratorio. Trabajamos con el mismo ciclo de siempre:

```text
Observar → Pedir un cambio → Leer → Modificar → Probar → Conservar o deshacer
```

### Convenciones

| Símbolo | Significado |
|---|---|
| 💡 **Concepto** | Una idea que necesitamos comprender antes de programar |
| 🤖 **Pedido al agente** | Una instrucción que podemos darle a una IA |
| ✏️ **Editar** | Un cambio que realizaremos en `app.py` |
| ▶️ **Ejecutar** | Probar la aplicación |
| ✅ **Verificar** | Comprobar un resultado esperado |
| ⚠️ **Riesgo** | Algo que debemos revisar antes de aceptar o ejecutar |

### Regla principal

> La IA puede proponer y escribir código, pero la persona sigue siendo responsable de comprenderlo, probarlo y decidir si lo acepta.

---

## 1. ¿Qué problema resuelve RAG? — 15 minutos

### 💡 Concepto: las dos limitaciones de un LLM

Nuestro chatbot actual responde con su **conocimiento general**. Eso tiene dos problemas:

1. **No sabe** lo que no está en sus datos de entrenamiento: el horario del Circo Aurora, sus precios, sus reglas.
2. **Igual responde**: ante un hueco de conocimiento produce un texto plausible, convencido y falso. Eso es una **alucinación**.

RAG ataca el problema por el lado de los datos: antes de generar, **buscamos en una fuente propia** los fragmentos relevantes y los entregamos al modelo como evidencia. El modelo ya no recuerda: **lee y redacta**.

```text
pregunta → recuperar fragmentos → generar respuesta fundamentada
                     ↓
             si no hay evidencia
                     ↓
             responder "no sé" y escalar
```

### Las tres etapas de un sistema RAG

| Etapa | Qué hace | En esta clase |
|---|---|---|
| **Indexar** | Preparar la fuente: extraer texto y trocearlo en fragmentos | `pypdf` + troceado |
| **Recuperar** | Ante una pregunta, elegir los fragmentos más relevantes | Embeddings + similitud |
| **Generar** | Redactar la respuesta usando solo esa evidencia | LLM local con prompt restringido |

> **La clave:** la verdad ya no vive en el modelo, vive en el documento. Si el PDF cambia, el asistente mejora sin reentrenar nada.

---

## 2. Preparar el material — 10 minutos

### 📁 Archivos que necesitamos

En la carpeta `modulo_4/` ya tenemos:

- `circo_aurora.txt` — la base de conocimiento en texto plano;
- `circo_aurora.pdf` — la misma información en formato PDF (generado para esta clase).

Vamos a usar el **PDF** porque es el formato real de manuales, reglamentos y documentación de negocio.

### ▶️ Verificar que el PDF existe

En la terminal:

```bash
ls -la modulo_4/circo_aurora.pdf
```

### ✅ Verificar

- El archivo `circo_aurora.pdf` aparece en la lista.

### ⚠️ Riesgo

> No borres `circo_aurora.txt`. En la Clase 4 lo usaremos para comparar el enfoque por texto plano con el de base vectorial.

---

## 3. Instalar las dependencias — 10 minutos

Para leer el PDF y convertir texto en embeddings necesitamos dos librerías nuevas.

### 🖥️ Terminal

```bash
pip install pypdf sentence-transformers
```

> `sentence-transformers` descarga un modelo de embeddings la primera vez que se usa. Puede tardar unos minutos y necesita conexión a internet.

### ✅ Verificar

```bash
python -c "import pypdf; print('pypdf OK')"
python -c "import sentence_transformers; print('sentence_transformers OK')"
```

Ambos comandos deben imprimir `OK` sin errores.

### ⚠️ Riesgo

> Si `pip` falla por un error de certificado SSL, ejecutá el comando desde la terminal de Visual Studio Code (fuera del sandbox) o consultá al docente.

---

## 4. Leer el PDF con pypdf — 20 minutos

### 💡 Concepto: extraer texto de un PDF

Un PDF no es un archivo de texto: es un conjunto de objetos gráficos. Para leerlo necesitamos una librería que **extraiga** el texto. `pypdf` hace exactamente eso.

### 🤖 Pedido al agente

Pegá el contenido actual de `app.py` y luego escribí:

```text
Tengo un chatbot funcional hecho con Streamlit y
llama-cpp-python. Quiero agregar una función que lea un
PDF y devuelva su texto.

Creá una función leer_pdf(ruta) que:
- use pypdf.PdfReader;
- recorra todas las páginas;
- extraiga el texto de cada una con extract_text();
- devuelva el texto completo como una sola cadena.

No modifiques cargar_modelo() ni responder() todavía.
No agregues dependencias nuevas (pypdf ya está instalado).

Mostrá solamente la función nueva y explicá dónde colocarla.
Proponé una prueba para comprobarla.
```

### ✏️ Editar

Agregá la función `leer_pdf()` en `app.py`, en la **CAPA 2 · LÓGICA**, antes de `responder()`.

### ▶️ Ejecutar

Para probar la función sin abrir la app completa, ejecutá en la terminal:

```bash
python -c "
from app import leer_pdf
texto = leer_pdf('modulo_4/circo_aurora.pdf')
print(texto[:300])
"
```

### ✅ Verificar

- El texto impreso empieza con "Circo Aurora".
- Se ven las secciones: Espectáculos, Horarios, Precios, etc.

### ⚠️ Riesgo

> Si `extract_text()` devuelve texto con saltos de línea raros, no te preocupes: es normal en PDFs. El troceado de la siguiente sección lo va a limpiar.

---

## 5. Trocear el documento en fragmentos — 20 minutos

### 💡 Concepto: por qué trocear

Un documento entero es demasiado grande para usarlo como evidencia. Además, una pregunta casi siempre se responde con **una parte**, no con todo el manual. Trocear convierte el PDF en una mini-base de datos de fragmentos recuperables.

> **Decisión de diseño:** troceamos **por oración**, no por sección completa. Un fragmento corto tiene un significado concentrado, y la recuperación por embeddings funciona mejor que con secciones largas. Este es un detalle real de RAG: el tamaño del fragmento importa.

### 🤖 Pedido al agente

```text
Tengo una función leer_pdf(ruta) que devuelve el texto de
un PDF como una sola cadena.

Quiero agregar una función trocear_texto(documento) que
divida el texto en fragmentos por oración.

El documento tiene títulos de sección que son líneas cortas
sin punto final: "Espectáculos", "Horarios", "Precios",
"Reglas para el público" y "Ubicación".

La función debe:
1. recorrer el texto línea por línea;
2. si la línea es un título de sección, recordarlo como la
   sección actual;
3. si no, dividir la línea en oraciones (con re.split por
   punto, signo de pregunta o exclamación);
4. por cada oración de más de 15 caracteres, crear un
   fragmento con:
   - id: "FR01", "FR02", ... en orden;
   - titulo: la sección actual;
   - contenido: la oración.

No modifiques leer_pdf() ni responder().
Mostrá la función nueva y proponé una prueba.
```

### ✏️ Editar

Agregá `trocear_texto()` en `app.py`, junto a `leer_pdf()`. Necesitás `import re` al inicio del archivo.

### ▶️ Ejecutar

```bash
python -c "
from app import leer_pdf, trocear_texto
texto = leer_pdf('modulo_4/circo_aurora.pdf')
fragmentos = trocear_texto(texto)
print('Total:', len(fragmentos))
for f in fragmentos[:6]:
    print(f['id'], '—', f['titulo'], '|', f['contenido'][:40])
"
```

### ✅ Verificar

- Aparecen alrededor de 19 fragmentos.
- Cada uno tiene su `id`, `titulo` (la sección) y `contenido` (una oración).
- Los primeros fragmentos pertenecen a la sección "Espectáculos".

---

## 6. Convertir texto en embeddings — 25 minutos

### 💡 Concepto: qué es un embedding

Un **embedding** es una lista de números que representa el **significado** de un texto. Textos con significado parecido quedan cerca en el espacio numérico. Esto nos permite buscar "¿a qué hora abre la puerta?" y encontrar el fragmento de Horarios, aunque no compartan palabras exactas.

> En la Clase 6 del Módulo 4 buscábamos por palabras compartidas (búsqueda literal). Los embeddings buscan por **significado**. Esa es la gran diferencia.

### 🤖 Pedido al agente

```text
Tengo un chatbot con Streamlit y llama-cpp-python. Ya tengo
las funciones leer_pdf(ruta) y trocear_texto(documento).

Quiero agregar una función crear_embeddings(fragmentos) que:
- use sentence_transformers.SentenceTransformer;
- use el modelo "paraphrase-multilingual-mpnet-base-v2"
  (soporta español y da buena separación de significados);
- convierta CADA fragmento en un vector;
- para cada fragmento, use el título + el contenido
  (ej: "Horarios. La función empieza a las 20:30...");
- devuelva una lista de vectores en el mismo orden que los
  fragmentos.

Cargá el modelo UNA SOLA VEZ (podés usar @st.cache_resource
como en cargar_modelo()).

No modifiques las funciones existentes.
Mostrá la función nueva y explicá cómo se usa.
```

### ✏️ Editar

Agregá `crear_embeddings()` en `app.py`.

### ⚠️ Riesgo

> La primera vez, `sentence-transformers` descarga el modelo desde Hugging Face. Si no hay internet, la app fallará. Avisá al docente si esto ocurre.

### ▶️ Ejecutar

```bash
python -c "
from app import leer_pdf, trocear_texto, crear_embeddings
texto = leer_pdf('modulo_4/circo_aurora.pdf')
fragmentos = trocear_texto(texto)
vectores = crear_embeddings(fragmentos)
print('Fragmentos:', len(fragmentos))
print('Dimensión del vector:', len(vectores[0]))
"
```

### ✅ Verificar

- Se imprimen alrededor de 19 fragmentos.
- La dimensión del vector es **768** (el modelo mpnet genera vectores de 768 números).

---

## 7. Recuperar los fragmentos más relevantes — 25 minutos

### 💡 Concepto: similitud por coseno

Para saber qué fragmento responde mejor a una pregunta, convertimos la pregunta en un embedding y medimos la **similitud por coseno** con cada fragmento. El fragmento con mayor similitud es el más relevante.

### 🤖 Pedido al agente

```text
Tengo las funciones leer_pdf, trocear_texto y
crear_embeddings en app.py.

Quiero agregar una función recuperar_evidencia(pregunta,
fragmentos, vectores, k=2) que:
- convierta la pregunta en un embedding;
- calcule la similitud por coseno entre la pregunta y cada
  fragmento;
- devuelva los k fragmentos más parecidos, ordenados de
  mayor a menor similitud;
- incluya en cada resultado el puntaje de similitud.

Usá numpy para el cálculo del coseno.

No modifiques las funciones existentes.
Mostrá la función nueva y proponé tres preguntas de prueba.
```

### ✏️ Editar

Agregá `recuperar_evidencia()` en `app.py`.

### ▶️ Ejecutar

```bash
python -c "
from app import leer_pdf, trocear_texto, crear_embeddings, recuperar_evidencia
texto = leer_pdf('modulo_4/circo_aurora.pdf')
fragmentos = trocear_texto(texto)
vectores = crear_embeddings(fragmentos)
for q in ['¿A qué hora es la función del sábado?',
          '¿Se puede entrar con comida?',
          '¿Venden pizza en el circo?']:
    r = recuperar_evidencia(q, fragmentos, vectores)
    print(q, '→', r[0]['titulo'], '| similitud:', round(r[0]['puntaje'], 3))
"
```

### ✅ Verificar

- "¿A qué hora es la función del sábado?" → **Horarios** (similitud alta, ~0.72).
- "¿Se puede entrar con comida?" → **Reglas para el público** (similitud ~0.52).
- "¿Venden pizza en el circo?" → similitud baja (~0.44, no hay evidencia real).

> Notá cómo los embeddings encuentran la sección correcta aunque la pregunta use palabras distintas a las del documento. Eso no era posible con la búsqueda literal del Módulo 4.

---

## 8. Conectar la evidencia con el LLM — 25 minutos

### 💡 Concepto: el prompt restringido

Ahora modificamos `responder()` para que use la evidencia. El prompt del sistema le dice al modelo: *"respondé usando únicamente la evidencia; si no alcanza, decí que no sabés"*.

### 🤖 Pedido al agente

```text
Tengo un chatbot con Streamlit y llama-cpp-python. Ya tengo
las funciones leer_pdf, trocear_texto, crear_embeddings y
recuperar_evidencia.

Quiero modificar la función responder() para que:
1. lea el PDF y trocee el texto (una sola vez, podés usar
   @st.cache_resource);
2. ante cada pregunta, recupere la evidencia con
   recuperar_evidencia();
3. si la similitud del mejor fragmento es menor a 0.5,
   responda "No tengo ese dato en mi información. Consultá
   en boletería.";
4. si hay evidencia, arme el system prompt con la evidencia
   y pida al modelo que responda usando SOLO esa evidencia;
5. use temperature=0 para respuestas deterministas.

No cambies cargar_modelo() ni la interfaz.
Mostrá la función responder() modificada completa y explicá
cada cambio.
```

### ✏️ Editar

Modificá `responder()` en `app.py`.

### ⚠️ Riesgo

> Revisá que el umbral de similitud (0.5) sea razonable. Si el chatbot se niega demasiado, bajalo; si acepta evidencia débil, subilo. Es un **hiperparámetro** que se ajusta probando.

### ▶️ Ejecutar

```bash
streamlit run app.py
```

### ✅ Verificar

En el navegador:

1. Preguntá: `¿A qué hora es la función del sábado?` → debe responder con el horario del PDF.
2. Preguntá: `¿Se puede entrar con comida?` → debe citar la regla.
3. Preguntá: `¿Venden pizza en el circo?` → debe decir que no tiene ese dato.

---

## 9. Comprobación final — 10 minutos

### ✅ Lista de verificación

- [ ] `leer_pdf()` extrae el texto del PDF.
- [ ] `trocear_texto()` produce fragmentos por oración (~19).
- [ ] `crear_embeddings()` genera vectores de dimensión 768.
- [ ] `recuperar_evidencia()` encuentra la sección correcta.
- [ ] `responder()` usa la evidencia y se niega sin ella.
- [ ] La app corre con `streamlit run app.py`.

### Guardar una copia funcional

Antes de seguir, guardá una copia del archivo:

```text
app_clase3_rag_pdf.py
```

Esta copia es tu respaldo. Si la Clase 4 rompe algo, podés volver acá.

---

## Resumen

| Etapa RAG | Función en `app.py` | Librería |
|---|---|---|
| Indexar | `leer_pdf()` + `trocear_texto()` | `pypdf` |
| Recuperar | `crear_embeddings()` + `recuperar_evidencia()` | `sentence-transformers` |
| Generar | `responder()` | `llama-cpp-python` |

**En la Clase 4** vamos a dar el paso siguiente: guardar los embeddings en una **base de datos vectorial** (ChromaDB) para que la búsqueda sea rápida y escalable, en lugar de recalcular la similitud contra todos los fragmentos en cada pregunta.
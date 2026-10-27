# Clase 2 — Vibe coding: mejorar una app con IA sin perder el control

> **Formato:** Turno 2 de la Semana 1 (2 horas). Partimos del chatbot funcional de la Clase 1 y usamos un agente de inteligencia artificial para mejorarlo de manera gradual, entendible y comprobable.

## Pregunta central de la clase

> ¿Cómo podemos usar un agente de inteligencia artificial para modificar una aplicación sin aceptar código a ciegas ni convertir una solución sencilla en algo innecesariamente complejo?

## Objetivos de la clase

- Entender qué es el **vibe coding** o programación asistida con IA.
- Aprender a pedir código concreto, útil y comprobable.
- Reconocer los riesgos de la sobreingeniería.
- Reconocer los riesgos de ejecutar código que no entendemos.
- Conectar Visual Studio Code con una cuenta de GitHub para usar GitHub Copilot Chat.
- Distinguir cuándo usar los modos Ask, Plan y Agent.
- Revisar permisos antes de permitir que el agente edite archivos o ejecute comandos.
- Mantener siempre una versión funcional de la aplicación.
- Realizar un cambio por vez y comprobarlo antes de continuar.
- Incorporar un `system prompt` separado de la pregunta del usuario.
- Mejorar la interfaz del chatbot con componentes sencillos de Streamlit.

## Producto final

Al terminar la clase, nuestro chatbot tendrá:

- un `system prompt` que define cómo debe comportarse;
- respuestas finales sin el razonamiento interno del modelo;
- respuestas renderizadas como Markdown;
- información visible sobre el modelo utilizado;
- historial de conversación;
- un botón para borrar la conversación;
- un contador de mensajes.

## Cómo usar esta guía

Esta clase funciona como un laboratorio. No vamos a pedirle a la IA que rehaga toda la aplicación. Vamos a trabajar siempre con el mismo ciclo:

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

## 1. Empezar desde una aplicación que funciona — 10 minutos

Antes de mejorar el chatbot, comprobamos que el punto de partida funciona.

### ▶️ Ejecutar

En la terminal, dentro de la carpeta del proyecto:

```bash
streamlit run app.py
```

### ✅ Verificar el punto de partida

- El modelo carga correctamente.
- Podemos escribir una pregunta.
- El chatbot muestra una respuesta.
- Los mensajes anteriores permanecen en pantalla.
- Podemos enviar una segunda pregunta.

### Guardar una copia funcional

Antes de aceptar cambios generados por una IA, guardá una copia del archivo con el nombre:

```text
app_clase1_funcional.py
```

Esta copia es un respaldo. Si una modificación rompe la aplicación, podremos comparar ambos archivos o volver al punto de partida.

> **Buena práctica:** no empieces una mejora sin saber si el programa ya funcionaba. De lo contrario, no podrás distinguir un problema anterior de uno producido por el cambio.

---

## 2. ¿Qué es el vibe coding? — 15 minutos

El **vibe coding** es una forma de programar en la que describimos a una inteligencia artificial qué queremos construir o modificar, y la IA propone el código.

El trabajo no termina cuando la IA entrega una respuesta:

```text
Necesidad
   ↓
Pedido al agente
   ↓
Código propuesto
   ↓
Revisión humana
   ↓
Prueba
   ↓
Aceptar, corregir o deshacer
```

### ¿Quién es responsable de cada decisión?

| Responsabilidad | Persona | Agente de IA |
|---|:---:|:---:|
| Definir el objetivo | Sí | No |
| Proponer código | Puede | Sí |
| Explicar el cambio | Lo solicita y revisa | Sí |
| Decidir si el cambio es necesario | Sí | No |
| Ejecutar y comprobar | Sí | No |
| Aceptar el resultado final | Sí | No |

> El agente puede escribir código muy rápido. Eso no significa que el código sea necesario, correcto, seguro o compatible con nuestra aplicación.

---

## 3. Riesgos y preparación del asistente de IA — 30 minutos

### 3.1 Sobreingeniería

La **sobreingeniería** aparece cuando una solución incorpora más estructura y complejidad de la necesaria.

Para agregar un botón sencillo, un agente podría intentar:

- crear varios archivos nuevos;
- introducir clases y patrones avanzados;
- instalar dependencias adicionales;
- agregar una base de datos;
- crear un sistema de configuración;
- cambiar la carga del modelo;
- reescribir todo `app.py`.

Nada de eso es necesario para agregar un botón de Streamlit.

### Señales de alerta

- Modifica partes que no estaban incluidas en el pedido.
- Reemplaza todo el archivo para cambiar pocas líneas.
- Agrega librerías sin explicar por qué.
- Crea muchas funciones o archivos para una tarea pequeña.
- Cambia nombres o estructuras que ya funcionaban.
- Entrega código que no podemos explicar.

### 3.2 Ejecutar código que no entendemos

Antes de copiar o ejecutar código generado por una IA, debemos revisar especialmente instrucciones como:

```python
eval(...)
exec(...)
subprocess.run(...)
os.system(...)
```

También debemos detenernos si el agente propone:

- eliminar o mover archivos;
- instalar paquetes desconocidos;
- conectarse a servicios externos;
- leer contraseñas, tokens o claves;
- subir archivos personales;
- modificar carpetas ajenas al proyecto.

> **Regla de seguridad:** si no podés explicar qué hace una línea potencialmente sensible, no la ejecutes. Primero pedile al agente que la explique o consultá al docente.

### 3.3 Conectar Visual Studio Code con GitHub Copilot Chat

Para usar GitHub Copilot Chat, necesitás una cuenta de GitHub con acceso a Copilot. Puede ser un plan de una organización o el plan gratuito con sus límites de uso.

1. Abrí en Visual Studio Code la carpeta del proyecto.
2. Seleccioná el ícono de Copilot en la barra de estado y elegí **Use AI Features** o **Sign in to use Copilot**.
3. Elegí iniciar sesión con GitHub.
4. Completá la autorización en el navegador y regresá a Visual Studio Code.
5. Abrí el chat desde el ícono de Chat. También podés usar `Ctrl+Alt+I` en Windows y Linux, o `Control+Command+I` en macOS.
6. Verificá que el chat muestre tu cuenta y permita enviar una pregunta.

> Si no aparece Copilot, comprobá que Visual Studio Code esté actualizado y que hayas iniciado sesión con la misma cuenta que tiene acceso a Copilot.

Documentación de referencia: [configurar GitHub Copilot en Visual Studio Code](https://code.visualstudio.com/docs/setup/copilot).

#### Modos básicos de Copilot Chat

En la parte inferior del chat podemos elegir cómo queremos trabajar:

| Modo | Para qué sirve | Ejemplo de uso |
|---|---|---|
| **Ask** | Comprender código, hacer preguntas y recibir sugerencias sin pedir una modificación directa. | `Explicame qué hace la función responder(). No modifiques archivos.` |
| **Plan** | Analizar una tarea y preparar pasos antes de cambiar el proyecto. El plan se revisa antes de implementarlo. | `Prepará un plan para agregar un system prompt. No implementes todavía.` |
| **Agent** | Trabajar sobre una tarea concreta: puede leer y editar archivos, usar herramientas y proponer comandos. | `Implementá el plan aprobado solamente en responder() y mostrá los cambios.` |

> **Secuencia recomendada para esta clase:** usá **Ask** para comprender, **Plan** para delimitar el cambio y **Agent** cuando estés listo para implementarlo.

Los nombres o la ubicación de estas opciones pueden variar según la versión de Visual Studio Code o las políticas de la organización. Si no aparece **Agent**, puede estar deshabilitado por el administrador.

Documentación de referencia: [modos Ask, Plan y Agent](https://docs.github.com/en/copilot/how-tos/chat-with-copilot/chat-in-ide).

#### Permisos: qué estamos autorizando

En modo Agent, Copilot puede solicitar permiso para editar un archivo, ejecutar un comando en la terminal o acceder a una herramienta externa. Tener una herramienta habilitada no significa que todas sus acciones deban aprobarse automáticamente.

Para esta clase, mantené seleccionados los **permisos manuales** y revisá cada solicitud antes de aceptarla:

1. Leé qué archivo quiere modificar o qué comando quiere ejecutar.
2. Comprobá que la acción pertenezca al cambio que pediste.
3. Preferí **aprobar una vez** cuando todavía estás aprendiendo.
4. Revisá el diff o comparación antes de conservar una edición.
5. No autorices acciones que eliminen archivos, instalen paquetes, accedan a secretos o se conecten a servicios externos si no entendés por qué son necesarias.

> **Configuración del laboratorio:** no usaremos **Allow all**, **Bypass Approvals** ni **Autopilot**. Reducen las confirmaciones y no son necesarios para los cambios pequeños de esta clase.

Documentación de referencia: [aprobaciones y permisos en Visual Studio Code](https://code.visualstudio.com/docs/agents/run/approvals).

---

## 4. Cómo pedir código útil y comprobable — 15 minutos

Un buen pedido de programación tiene seis componentes:

| Componente | Pregunta que responde |
|---|---|
| Contexto | ¿Qué aplicación tengo? |
| Estado actual | ¿Qué funciona ahora? |
| Cambio | ¿Qué quiero agregar? |
| Alcance | ¿Qué parte puede modificar? |
| Restricciones | ¿Qué no debe tocar? |
| Comprobación | ¿Cómo sabré que funciona? |

### Un pedido demasiado abierto

```text
Mejorá mi chatbot y hacelo más profesional.
```

El agente tendrá que adivinar qué significa “mejorar”. Puede modificar demasiado, agregar funciones que no necesitamos o romper algo que ya funcionaba.

### Plantilla para trabajar con el agente

```text
Tengo una aplicación de chatbot hecha con Python, Streamlit
y llama-cpp-python.

Actualmente funciona y [DESCRIBIR QUÉ HACE].

Quiero agregar solamente [UN CAMBIO CONCRETO].

Podés modificar [INDICAR EL BLOQUE PERMITIDO].

No cambies:
- la carga del modelo;
- otras funciones que ya funcionan;
- las dependencias del proyecto.

Antes de darme el código:
1. Explicá qué vas a modificar.
2. Indicá si la aplicación ya tiene parte de esa funcionalidad.
3. Señalá cualquier riesgo o supuesto.

Después:
1. Mostrá solamente los bloques que debo cambiar.
2. Explicá cada cambio con palabras sencillas.
3. Proponé tres pruebas para comprobarlo.
```

---

## 5. Primera mejora: incorporar un system prompt — 25 minutos

El primer cambio será sobre la función `responder()`. Lo hacemos antes de modificar la interfaz porque define el comportamiento central del chatbot.

### 💡 ¿Qué es un system prompt?

Un `system prompt` es una instrucción que define el rol, el estilo y los límites generales del asistente. No es una pregunta del usuario: es parte de la configuración de la aplicación.

Vamos a separar dos tipos de mensajes:

| Rol | Contenido |
|---|---|
| `system` | Cómo debe comportarse el asistente |
| `user` | La pregunta escrita en el chat |

### Comportamiento que buscamos

Nuestro chatbot debe:

- responder en español claro;
- actuar como asistente educativo;
- explicar conceptos con palabras sencillas;
- usar ejemplos breves cuando ayuden;
- reconocer cuando no conoce una respuesta;
- no inventar datos ni acciones realizadas;
- usar Markdown cuando mejore la lectura.

### 🤖 Pedido al agente

Pegá el contenido actual de `app.py` y luego escribí:

```text
Tengo un chatbot funcional hecho con Streamlit y
llama-cpp-python.

Quiero realizar un único cambio: modificar la función
responder() para usar un system prompt mediante
llm.create_chat_completion().

El system prompt debe indicar que el modelo:
- es un asistente educativo;
- responde en español claro;
- explica con palabras sencillas;
- usa ejemplos breves cuando son útiles;
- reconoce cuando no conoce una respuesta;
- no inventa datos ni acciones realizadas;
- puede usar Markdown para organizar la respuesta.

La llamada debe enviar:
- el system prompt con el rol "system";
- la pregunta con el rol "user";
- temperature=0.3.

La respuesta se obtiene desde:
salida["choices"][0]["message"]["content"]

Si aparece la etiqueta </think>, eliminá la etiqueta y todo
lo que se encuentre antes de ella.

No modifiques cargar_modelo(), el historial ni la interfaz.
No agregues dependencias nuevas.

Antes de mostrar el código, explicá qué líneas vas a cambiar.
Después mostrá solamente los bloques que debo reemplazar y
proponé tres preguntas para comprobar el resultado.
```

### Antes de copiar el resultado

Revisá que la propuesta:

- incorpore `import re` si utiliza expresiones regulares;
- defina el `system prompt` en un lugar fácil de encontrar;
- use `create_chat_completion()`;
- conserve el parámetro `max_tokens`;
- no cambie `cargar_modelo()`;
- no reescriba la interfaz;
- no agregue paquetes nuevos.

### ✅ Pruebas del system prompt

| Pregunta | Qué comprobamos |
|---|---|
| `¿Qué es una variable?` | Lenguaje claro y educativo |
| `Explicalo usando una lista.` | Uso de Markdown |
| `¿Qué desayuné hoy?` | Reconocimiento de información desconocida |

Comprobá también que no aparezca el razonamiento anterior a `</think>`.

> **No continúes si este cambio no funciona.** Volvé a la versión anterior, compará los bloques y pedile al agente que corrija solamente el error encontrado.

---

## 6. Mejoras controladas de la interfaz — 25 minutos

Ahora que la función central está comprobada, podemos mejorar la interfaz. Aplicaremos cada mejora por separado y volveremos a ejecutar la app después de cada una.

### 6.1 Mostrar información sobre el modelo

Queremos mostrar en la barra lateral:

- el repositorio del modelo;
- el nombre del archivo GGUF;
- una aclaración de que el modelo se ejecuta localmente.

#### 🤖 Pedido al agente

```text
Quiero agregar en st.sidebar información sobre el modelo con
el que estoy chateando:
- repositorio del modelo;
- nombre del archivo GGUF;
- el texto "El modelo se ejecuta localmente".

Evitá repetir esos datos en distintos lugares: proponé dos
constantes con nombres claros y reutilizalas tanto en
cargar_modelo() como en la barra lateral.

No cambies la función responder(), el historial ni las
dependencias. Mostrá solamente los bloques modificados y
explicá dónde colocarlos.

El cambio funciona si veo los datos correctos en la barra
lateral y el chatbot continúa respondiendo.
```

#### ✅ Verificar

- La barra lateral aparece.
- Los datos coinciden con el modelo realmente cargado.
- El modelo se carga una sola vez.
- El chatbot continúa respondiendo.

### 6.2 Revisar el historial antes de modificarlo

La aplicación de la Clase 1 ya guarda los mensajes en:

```python
st.session_state.mensajes
```

Por eso no necesitamos pedir “agregá un historial”. Primero debemos pedirle al agente que reconozca y reutilice la solución existente.

> **Lección:** antes de pedir una función, verificá si el programa ya la tiene. Duplicar una solución existente también es sobreingeniería.

### 6.3 Agregar un botón para borrar la conversación

#### 🤖 Pedido al agente

```text
Mi chatbot ya guarda el historial en
st.session_state.mensajes.

Agregá en la barra lateral un botón llamado
"Borrar conversación".

Al presionarlo:
- debe vaciar st.session_state.mensajes;
- la interfaz debe actualizarse;
- debe ser posible iniciar una nueva conversación.

No agregues un segundo historial.
No modifiques cargar_modelo() ni responder().
No agregues dependencias.

Mostrá solamente las líneas nuevas, explicá dónde colocarlas
y proponé tres pruebas manuales.
```

#### ✅ Verificar

1. Enviá dos mensajes.
2. Presioná el botón.
3. Confirmá que la conversación desaparece.
4. Enviá una nueva pregunta.
5. Confirmá que el chatbot continúa funcionando.

### 6.4 Agregar un contador de mensajes

#### 🤖 Pedido al agente

```text
Agregá en la barra lateral un contador que muestre cuántos
mensajes hay en st.session_state.mensajes.

No crees otra lista ni otra variable de historial.
No cambies cargar_modelo() ni responder().
No agregues dependencias.

El contador debe actualizarse al enviar mensajes y volver a
cero al borrar la conversación.
```

#### ✅ Verificar

- El contador comienza en cero.
- Aumenta con la conversación.
- Coincide con los mensajes visibles.
- Vuelve a cero al borrar el historial.

### 6.5 Renderizar las respuestas como Markdown

Pedile al agente que localice únicamente los lugares donde se muestran mensajes del asistente y reemplace allí `st.write()` por `st.markdown()`.

#### Restricciones

- No debe modificar la generación de la respuesta.
- No debe habilitar `unsafe_allow_html=True`.
- No debe cambiar cómo se muestran los mensajes del usuario.

#### ✅ Verificar

Pedile al chatbot una respuesta que contenga:

- un título;
- una lista con viñetas;
- un fragmento de código.

Los tres elementos deben aparecer con formato.

---

> Programar con agentes no significa entregarles el control del proyecto. Significa usarlos para proponer cambios mientras la persona conserva la responsabilidad de comprender, probar y decidir.

---

## Resumen de la Semana 1

| Clase | Qué lograste |
|---|---|
| Clase 1 | Construiste un chatbot web con Streamlit y un LLM local |
| Clase 2 | Aprendiste a mejorarlo con un agente de IA mediante cambios pequeños, explicables y comprobables |

**En la Semana 2** vamos a trabajar sobre una nueva limitación: el chatbot responde con conocimiento general y puede inventar información. Incorporaremos RAG para que pueda consultar el contenido real del curso antes de responder.

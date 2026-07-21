# Curso Experto en Arquitectura y Desarrollo de Inteligencia Artificial

Este repositorio contiene el material de clases para el curso de **IA Aplicada**. Está diseñado para estudiantes y profesionales interesados en aprender sobre inteligencia artificial aplicada, desde conceptos básicos hasta implementaciones prácticas.

## Estructura del Curso

### Módulo 1: Introducción a la IA
- **Clase 1**: ¿Qué es la IA?
- **Clase 2**: Proyectos de IA
- **Clase 3**: Tu primer dataset (Pandas inicial)
- **Clase 4**: Cómo aprende una máquina (Paradigmas ML)
- **Clase 5**: Sesgos y justicia en IA
- **Clase 6**: Privacidad, gobernanza e ISO 42001
- **Clase 7**: Conceptos de LLM (Cómo aprende a hablar una máquina)
- **Clase 8**: Práctica con LLM usando LlamaCPP

### Módulo 2: Prompt Engineering y ML con Scikit-Learn
- **Clase 1**: Anatomía del prompt
- **Clase 2**: Errores y patrones comunes
- **Clase 3**: Estrategias Few-shot y Zero-shot
- **Clase 4**: Razonamiento con Chain of Thought
- **Clase 5**: Repositorio de prompts
- **Clase 6**: Introducción a Machine Learning con Scikit-Learn
- **Clase 7**: Pipeline de ML completo
- **Clase 8**: Modelos de Clasificación
- **Clase 9**: Regresión y establecimiento de Baselines
- **Bonus**: [Notebook 11](modulo_2/11.ipynb)

### Módulo 3: Programación para IA (Python, NumPy, Pandas y Scikit-Learn)
- **Clase 1-2**: Python para principiantes
- **Clase 3**: Algoritmos y pensamiento computacional
- **Clase 4**: Lógica booleana
- **Clase 5**: Condicionales en Python
- **Clase 6**: Bucles y repetición
- **Clase 7**: Listas, diccionarios y datasets para IA
- **Clase 8**: Funciones y reutilización para IA
- **Clase 9**: NumPy básico
- **Clase 10**: NumPy aplicado y Pandas intro
- **Clase 11**: Pandas: manipulación de datos para IA
- **Clase 12**: Pandas y tu primer clasificador divertido
- **Clase 13**: Comparar modelos con gráficas
- **Clase 14**: Proyecto divertido de clasificación (frontera de decisión)

### Módulo 4: LLMs locales y Tokenización
- **Clase 1**: Mi primer LLM CHAT con `llama.cpp` (`modulo_4/Clase 1 - Mi primer LLM CHAT.ipynb`)
- **Clase 2**: Entrenar un modelo BPE (Byte Pair Encoding) (`modulo_4/Clase 2 - Entrenar un modelo BPE.ipynb`)

### Módulo 5: Retrieval-Augmented Generation (RAG)
- Demo funcional de RAG (`modulo_5/rag_demo.ipynb`)

## Guía de Instalación Paso a Paso

Para poder ver y ejecutar las prácticas del curso en tu computadora, vas a necesitar preparar tu entorno de trabajo. No te preocupes si no tienes mucha experiencia, aquí te explicamos cómo hacerlo paso a paso.

### Opción 1: Instalación Automática en Windows (¡Recomendada!)

Esta es la forma más fácil. Hemos creado un asistente que hace todo el trabajo pesado por ti (instalar programas, descargar las clases y configurar todo).

**Paso 1:** Abre el menú de Inicio de Windows.

**Paso 2:** Escribe `PowerShell`. Verás una aplicación llamada "Windows PowerShell". Haz clic derecho sobre ella y elige **"Ejecutar como administrador"** (te puede pedir confirmación, dile que sí).

**Paso 3:** Copia el siguiente texto, pégalo en la ventana azul que se abrió y presiona `Enter` (la tecla intro):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; & ([scriptblock]::Create((Invoke-RestMethod 'https://raw.githubusercontent.com/TataInti/clases/main/scripts/setup_windows.ps1')))"
```

**¿Qué hace este código mágico?**
Hace todo lo necesario para que no tengas que preocuparte por nada técnico:
- Instala los programas base si no los tienes (Git, Visual Studio Code y el lenguaje de programación Python 3.12).
- Configura Visual Studio Code con las herramientas que usaremos.
- Descarga la última versión de todas las clases del curso.
- Prepara todas las herramientas de Inteligencia Artificial que vamos a utilizar.
- Al final, abrirá los archivos solos y todo estará listo para empezar a trabajar.

¡Solo espera a que la pantalla azul termine de trabajar y listo! El material quedará guardado en tu computadora en la carpeta `GitHub\clases` (dentro de tu carpeta principal de usuario).

<details>
<summary>⚙️ Opciones avanzadas (solo si sabes lo que haces)</summary>

- Si ya tienes la carpeta descargada y solo quieres ejecutar el archivo manualmente:
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\scripts\setup_windows.ps1
  ```
- Si quieres elegir otra carpeta donde guardar todo (por ejemplo, la carpeta "Cursos"):
  ```powershell
  powershell -ExecutionPolicy Bypass -File .\scripts\setup_windows.ps1 -InstallRoot "$env:USERPROFILE\Cursos"
  ```
</details>

<details>
<summary>🔴 ¿El comando falla con un error de red o "no se pudo resolver el nombre"?</summary>

El mensaje `The remote name could not be resolved: 'raw.githubusercontent.com'` significa que tu computadora no pudo conectarse a Internet en ese momento. No es un problema con el script en sí.

**Antes de volver a intentarlo, prueba lo siguiente:**

1. **Verifica tu conexión a Internet.** Abre el navegador y fijate si podés entrar a cualquier página web. Si no entrás a ninguna, el problema es la conexión (WiFi o cable).

2. **Si usás WiFi**, desconéctate y volvé a conectarte a la red. También podés intentar usar los datos móviles de tu celular como punto de acceso (hotspot).

3. **Si el problema persiste**, es posible que el servidor DNS (el "directorio telefónico" de Internet) de tu red esté fallando. Podés solucionarlo cambiando el DNS a uno público:
   - Abrí el menú de Inicio → escribí `Panel de control` → **Centro de redes y recursos compartidos**.
   - Hacé clic en tu conexión activa (ej. "WiFi") → **Propiedades**.
   - Seleccioná **"Protocolo de Internet versión 4 (TCP/IPv4)"** → **Propiedades**.
   - Marcá **"Usar las siguientes direcciones de servidor DNS"** e ingresá:
     - Servidor DNS preferido: `8.8.8.8`
     - Servidor DNS alternativo: `8.8.4.4`
   - Guardá los cambios y volvé a intentar el comando.

4. **Si estás en una red de empresa o colegio**, puede que un firewall o proxy esté bloqueando la conexión a GitHub. Probá desde una red de casa o con los datos del celular.

5. **Alternativa sin internet:** Si no podés conectarte, usá la **Opción 2: Instalación Manual** que se describe más abajo. Solo necesitarás descargar el material en otro momento o desde otro dispositivo.

</details>

---

### Opción 2: Instalación Manual (macOS, Linux o usuarios avanzados de Windows)

Si no usas Windows o prefieres instalar las cosas por tu cuenta, sigue estos pasos:

**Paso 1: Instalar Python**

Primero verificá si ya tenés Python instalado. Abrí una terminal (en Windows buscá `cmd` o `PowerShell` en el menú de Inicio) y escribí:

```bash
python --version
```

Si ves algo como `Python 3.12.3`, ya está instalado y podés pasar al Paso 2. Si el comando no se reconoce o la versión es muy vieja (menor a 3.10), seguí estos pasos según tu sistema operativo:

<details>
<summary>Windows</summary>

La forma más fácil es con `winget` (viene preinstalado en Windows 10/11 moderno). En PowerShell:
```powershell
winget install -e --id Python.Python.3.12
```
Cuando termine, **cerrá y volvé a abrir PowerShell** para que Windows reconozca el nuevo comando `python`.

Si `winget` no funciona, descargá el instalador desde [python.org/downloads](https://www.python.org/downloads/). Durante la instalación, **asegurate de tildar la opción "Add Python to PATH"** antes de hacer clic en "Install Now".
</details>

<details>
<summary>macOS</summary>

La forma recomendada es con [Homebrew](https://brew.sh). Si no lo tenés, instalalo primero pegando esto en la Terminal:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Luego instalá Python:
```bash
brew install python@3.12
```
</details>

<details>
<summary>Linux (Ubuntu/Debian)</summary>

```bash
sudo apt update
sudo apt install python3.12 python3.12-venv python3-pip -y
```
</details>

**Paso 2: Descargar el material del curso**
Puedes ir al botón verde que dice **"Code"** arriba a la derecha en esta página y elegir **"Download ZIP"** (luego descomprimes la carpeta en tu computadora), o si sabes usar `git`, abre una terminal y clona el repositorio:
```bash
git clone https://github.com/TataInti/clases.git
cd clases
```

**Paso 3: Crear un entorno seguro de trabajo (entorno virtual)**
Para mantener tu computadora ordenada, vamos a crear un espacio aislado solo para las cosas de este curso. Abre una terminal dentro de la carpeta `clases` que acabas de descargar y escribe:
```bash
py -3.12 -m venv .venv
```
Luego actívalo:
- En **Windows**: `.venv\Scripts\activate`
- En **macOS/Linux**: `source .venv/bin/activate`

**Paso 4: Instalar las bibliotecas de Inteligencia Artificial**
Por último, vamos a instalar todas las herramientas matemáticas y de IA que usamos en las prácticas (como Scikit-learn, Torch y LlamaCPP). Asegúrate de que el entorno esté activado y escribe:
```bash
pip install -r requirements.txt
```

¡Eso es todo! Ya puedes abrir los archivos `.ipynb` en Visual Studio Code o en el lector de Jupyter que prefieras.

## Notas

- El material puede sufrir cambios a medida que se actualiza el curso.
- Este repositorio público solo incluye las clases y material didáctico.
- Los notebooks están en formato Jupyter (.ipynb) y requieren un entorno compatible para su ejecución.

## Contribuciones

Este es un repositorio educativo. Si encuentras errores o tienes sugerencias, por favor contacta al instructor.

## Licencia

MIT
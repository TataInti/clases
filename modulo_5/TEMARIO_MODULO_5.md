# Módulo 5 — Herramientas, frameworks, optimización y visualización

> Fuente: programa oficial del curso. Duración: 5 semanas de clases zoom.
> Solo 2 clases habilitadas en campus → hay que **jerarquizar** temas.
> Semana 5 = integración para el **TP FINAL**.

## Competencias que debe lograr el estudiante

- Configura y utiliza frameworks de Deep Learning (TensorFlow o PyTorch) para implementar y entrenar modelos de IA a escala y con alta eficiencia.
- Calcula e interpreta métricas de evaluación para analizar de forma crítica el rendimiento de un modelo, identificando fortalezas y debilidades.
- Aplica técnicas de Validación Cruzada y ajuste de hiperparámetros para optimizar el rendimiento del modelo, minimizando el overfitting y maximizando la generalización.
- Crea visualizaciones informativas y dashboards interactivos (Matplotlib, Seaborn, Tableau, dashboards) para comunicar resultados e insights.
- Utiliza herramientas de AutoML para automatizar la selección de modelos y aplica herramientas de IA Generativa para acelerar el prototipado y la creación de soluciones.
- Integra técnicas ETL para preparar los datos y vincula la IA con herramientas de Business Intelligence (BI) para impulsar la toma de decisiones basada en datos predictivos.
- Documenta y ejecuta un proceso de Mejora Continua del Sistema de Gestión de Inteligencia Artificial (SGIA) según la ISO 42001, asegurando sostenibilidad y cumplimiento ético-legal.
- Combina plataformas de procesamiento distribuido (Apache Spark) con servicios externos (OpenAI API) para gestionar y analizar grandes volúmenes de datos con modelos de lenguaje avanzados.

## Contenidos principales

- Fundamentos básicos de TensorFlow, PyTorch, OpenAI API, Apache Spark.
- Métricas: precisión, recall, F1-score.
- Validación cruzada y ajuste de hiperparámetros.
- Visualización con Matplotlib, Seaborn, Tableau, dashboards interactivos.
- AutoML e IA generativa.
- Técnicas ETL y Business Intelligence.
- Mejora continua SGIA (ISO 42001).

## Actividades y prácticas

- Lectura de material.
- Quizzes interactivos.
- Desarrollo de ejercitación variada.
- Prácticas con herramientas/frameworks.
- Análisis de métricas y optimización de modelos.
- Creación de dashboards interactivos.
- Trabajo de aplicación final para integrar contenidos.

## Clases sincrónicas (sugeridas)

- Taller práctico de herramientas y visualización.
- Aplicación de herramientas variadas de IA.
- Combinación de plataformas.

## Observaciones

- En el módulo 6 en el campus solo se habilitan dos clases. Por lo tanto el docente deberá preparar las clases zoom para las 5 semanas que dura el mismo, jerarquizando temas y agregando lo que considere necesario.
- En la semana 5 se hará una integración para el TP FINAL.

---

## Plan propuesto (5 semanas, jerarquizado)

> **Enfoque:** aprender haciendo. El hilo conductor es un **proyecto de chatbot web con RAG** que responde preguntas sobre el contenido del curso. Cada semana construye una pieza del proyecto y, de paso, cubre las competencias oficiales del temario.

| Semana | Qué construís | Competencia oficial que cubre |
|---|---|---|
| 1 | Chatbot web con Streamlit + LLM local (llama.cpp) | Arquitectura de apps de IA, LLM local |
| 2 | RAG: cargar notebooks, trocear, embeddings, ChromaDB | RAG, ETL de documentos |
| 3 | Evaluar la recuperación (precisión/recall/F1) | Métricas de evaluación |
| 4 | Optimizar: chunk size, top-k, temperatura, comparar modelos | Validación cruzada, hiperparámetros, AutoML |
| 5 | Desplegar la app web + documentar + SGIA | TP FINAL + Mejora Continua (ISO 42001) |

### Estructura de cada semana
- **1 clase por semana** (2 turnos de 2 horas = 4 horas), en formato guía `.md` con el paso a paso y el código comentado.
- El notebook queda **fuera** del flujo principal: el proyecto se arma como software real (archivos `.py`).

### Material de referencia (opcional)
- `Clase 1 - Deep Learning con Keras.ipynb` se conserva como **lectura complementaria** para quien quiera profundizar en redes neuronales, pero no es parte del camino principal del proyecto.

### Jerarquización para las 2 clases de campus
1. **Semana 1 + 2** (chatbot + RAG) → núcleo técnico del proyecto.
2. **Semana 5** (despliegue + TP FINAL + SGIA) → cierre y evaluación.

Semanas 3 y 4 (evaluación y optimización) funcionan bien como zoom asincrónico con práctica guiada sobre el proyecto.
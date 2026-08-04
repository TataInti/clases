# Curso 1 — Fundamentos comunes de IA para programadores

Módulo de nivelación para desarrolladores senior con experiencia de IA mínima o
despareja. Introduce el lenguaje, los criterios y las herramientas que los
cursos especializados de **Salud** e **Imagen** desarrollan en profundidad.

La prioridad es experimentar y explicar lo observado. No se pide implementar
algoritmos, ciclos de entrenamiento, transformers, detectores ni RAG desde cero.

## Clases

| # | Notebook | Práctica principal | Prepara para |
|---:|---|---|---|
| 1 | `01_ecosistema_entorno_y_proyectos.ipynb` | Diagnóstico y reglas frente a un árbol aprendido | Lenguaje común de ambos tracks |
| 2 | `02_machine_learning_algoritmos_y_evaluacion.ipynb` | Clasificación, regresión, splits y métricas | ML predictivo y evaluación |
| 3 | `03_datos_multimodales_y_embeddings.ipynb` | Texto, imagen, audio y ráster como representaciones | NLP, RAG, visión y multibanda |
| 4 | `04_redes_neuronales_y_frameworks.ipynb` | La misma MLP con PyTorch y Keras | Deep Learning de ambos tracks |
| 5 | `05_vision_clasificacion_deteccion_segmentacion.ipynb` | ResNet, YOLO nano, augmentation e IoU | Track Imagen: clases 1–2 |
| 6 | `06_audio_nlp_y_transformers.ipynb` | WAV, espectrograma, Whisper, attention y KV cache | Track Salud: clases 1–4 |
| 7 | `07_prompting_rag_y_agentes.ipynb` | Mini-RAG local, JSON y herramienta simulada | Track Salud: clases 5–7 |
| 8 | `08_datos_geoespaciales_y_pipeline.ipynb` | GeoTIFF, GeoJSON, NDVI y máscara de parcela | Track Imagen: clases 3–8 |

Cada clase sigue la misma secuencia: pregunta central, idea principal, glosario,
explicación visual, experimento guiado, preguntas de interpretación, actividad
de unos veinte minutos, síntesis y puente explícito al track correspondiente.

## Alcance de esta nivelación

Todos los conceptos importantes de los módulos siguientes aparecen al menos una
vez, pero con datos controlados y modelos pequeños o preentrenados.

- El **Track Salud** profundizará ASR/TTS, NLP clínico, prompting avanzado,
  vector stores, reranking, agentes conectados a SQL y feature engineering
  clínico.
- El **Track Imagen** profundizará entrenamiento de detectores, U-Net,
  Mask R-CNN, SAM, mAP sobre datasets, reproyecciones, ortomosaicos,
  Earth Engine/Sentinel Hub y pipelines agro productivos.
- Este curso no busca autonomía técnica en cada especialidad: busca que los
  alumnos puedan reconocer cada componente, leer un pipeline y formular buenas
  preguntas antes de especializarse.

El temario de referencia está en `curso/CURSO.docx` y no es modificado por el
generador.

## Preparación

Se requiere Python 3.12. Desde esta carpeta:

```bash
python3.12 -m venv .venv
source .venv/bin/activate        # macOS / Linux
# .venv\Scripts\activate         # Windows
python -m pip install --upgrade pip
python -m pip install -r requirements.txt
jupyter lab
```

Los notebooks están pensados para CPU y definen `FAST_MODE = True`. Después de
preparar modelos, cada uno debe completar `Run All` en menos de cinco minutos en
una computadora de desarrollo actual.

## Modelos y descargas

No se necesitan APIs, claves ni servicios pagos. La primera ejecución puede
descargar:

- ResNet18 para embeddings y clasificación visual;
- YOLO nano para la demostración de detección;
- Whisper Tiny para ASR;
- `all-MiniLM-L6-v2` para embeddings de texto;
- Qwen 2.5 Instruct 0.5B Q4 en GGUF para generación local
  (aproximadamente 500 MB).

Los modelos quedan en las caches habituales de PyTorch, Hugging Face y
Ultralytics. Para preparar un aula, ejecutar una vez todos los notebooks con
internet y después repetir con la red deshabilitada. Los notebooks distinguen
una inferencia real de un fallback; un fallback permite continuar una explicación
pero no satisface la validación del modelo.

## Assets locales

- `assets/audio/curso_ia_es.wav`: voz sintética en español creada para este
  curso; WAV PCM mono, 16 kHz, sin datos personales.
- `assets/geospatial/escena_multibanda.tif`: escena sintética reproducible con
  bandas azul, verde, roja y NIR en `EPSG:32720`.
- `assets/geospatial/parcela.geojson`: parcela sintética dentro de la escena,
  con el mismo CRS.
- `assets/images/`: imágenes pequeñas para ResNet/YOLO, con procedencia,
  atribución y términos documentados en `assets/images/README.md`.

Los archivos geoespaciales pueden regenerarse con:

```bash
python assets/geospatial/create_assets.py
python assets/images/create_assets.py
```

## Regenerar los notebooks

El contenido mantenible vive en `course_parts/` y los helpers compartidos en
`course_builder.py`. Para reemplazar los notebooks generados:

```bash
python build_notebooks.py
```

El generador valida la estructura pedagógica, retira los nombres de la versión
anterior y escribe notebooks limpios, sin outputs. Git conserva el historial.

## Criterios de validación

Antes de distribuir el material:

1. generar los ocho notebooks;
2. ejecutar cada uno desde un kernel limpio;
3. comprobar una primera pasada con descargas y una segunda desde cache;
4. confirmar que las actividades marcadas con `TODO` parten de valores válidos;
5. revisar los resultados específicos: baseline y test en ML, shapes de
   PyTorch/Keras, cajas/máscaras/IoU, transcripción real no vacía, retrieval,
   JSON parseable y CRS/NDVI consistentes.

Los artefactos producidos por las prácticas se escriben bajo `artifacts/`, que
está excluido de Git.

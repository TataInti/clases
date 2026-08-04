"""Genera los ocho notebooks mantenibles del Curso 1.

El contenido vive en ``course_parts``. Este archivo define la secuencia pública,
escribe notebooks sin outputs y retira los nombres de la versión anterior.
"""

from __future__ import annotations

from pathlib import Path

import nbformat as nbf

from course_parts.class_01_ecosistema import build as build_01
from course_parts.class_02_machine_learning import build as build_02
from course_parts.class_03_multimodal import build as build_03
from course_parts.class_04_redes_frameworks import build as build_04
from course_parts.class_05_vision import build as build_05
from course_parts.class_06_audio_nlp_transformers import build as build_06
from course_parts.class_07_prompting_rag_agents import build as build_07
from course_parts.class_08_geospatial import build as build_08


ROOT = Path(__file__).resolve().parent

NOTEBOOKS = {
    "01_ecosistema_entorno_y_proyectos.ipynb": build_01,
    "02_machine_learning_algoritmos_y_evaluacion.ipynb": build_02,
    "03_datos_multimodales_y_embeddings.ipynb": build_03,
    "04_redes_neuronales_y_frameworks.ipynb": build_04,
    "05_vision_clasificacion_deteccion_segmentacion.ipynb": build_05,
    "06_audio_nlp_y_transformers.ipynb": build_06,
    "07_prompting_rag_y_agentes.ipynb": build_07,
    "08_datos_geoespaciales_y_pipeline.ipynb": build_08,
}

LEGACY_NOTEBOOKS = [
    "01_que_es_ia_y_que_es_un_algoritmo.ipynb",
    "02_machine_learning_y_sus_algoritmos.ipynb",
    "03_como_aprende_un_modelo.ipynb",
    "04_redes_neuronales_sin_magia.ipynb",
    "05_como_ve_una_computadora.ipynb",
    "06_modelos_preentrenados_y_vision_practica.ipynb",
    "07_transformers_attention_y_kv_cache.ipynb",
    "08_mini_rag_local_paso_a_paso.ipynb",
]


def validate_source_notebook(name: str, notebook) -> None:
    """Chequeos estructurales rápidos antes de escribir el artefacto."""
    nbf.validate(notebook)
    sources = "\n".join(cell.get("source", "") for cell in notebook.cells)
    required = [
        "## Pregunta central",
        "Glosario mínimo",
        "TODO",
        "## Síntesis de la clase",
        "## Conexión con los tracks",
    ]
    missing = [marker for marker in required if marker not in sources]
    if missing:
        raise ValueError(f"{name}: faltan secciones requeridas: {missing}")


def main() -> None:
    for legacy_name in LEGACY_NOTEBOOKS:
        legacy_path = ROOT / legacy_name
        if legacy_path.exists():
            legacy_path.unlink()
            print(f"Retirado: {legacy_name}")

    for filename, factory in NOTEBOOKS.items():
        notebook = factory()
        validate_source_notebook(filename, notebook)
        target = ROOT / filename
        nbf.write(notebook, target)
        print(f"Generado: {target.name} ({len(notebook.cells)} celdas)")


if __name__ == "__main__":
    main()

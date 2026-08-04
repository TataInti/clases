"""Helpers compartidos para construir los notebooks del Curso 1."""

from __future__ import annotations

from pathlib import Path
from textwrap import dedent

import nbformat as nbf


ROOT = Path(__file__).resolve().parent


def md(text: str):
    return nbf.v4.new_markdown_cell(dedent(text).strip())


def code(text: str):
    return nbf.v4.new_code_cell(dedent(text).strip())


def intro(
    number: int,
    title: str,
    question: str,
    idea: str,
    objectives: list[str],
    sections: list[str],
    prepares_for: str,
):
    objectives_md = "\n".join(f"- {item}" for item in objectives)
    sections_md = "\n".join(
        f"| {index} | {item} |"
        for index, item in enumerate(sections, start=1)
    )
    source = (
        f"# Clase {number} — {title}\n\n"
        "## Pregunta central\n\n"
        f"> **{question}**\n\n"
        "## Idea principal\n\n"
        f"{idea}\n\n"
        "## Objetivos de aprendizaje\n\n"
        "Al finalizar la clase deberías poder:\n\n"
        f"{objectives_md}\n\n"
        "## Recorrido de la clase\n\n"
        "| Paso | Tema |\n"
        "|---:|---|\n"
        f"{sections_md}\n\n"
        "## Cómo trabajar con este notebook\n\n"
        "1. Ejecutá las celdas en el orden propuesto.\n"
        "2. Antes de modificar código, observá y describí el resultado.\n"
        "3. Cambiá solamente las variables marcadas con `TODO`.\n"
        "4. No es necesario implementar algoritmos desde cero.\n"
        "5. Si aparece un término nuevo, buscá primero su definición en el "
        "glosario de la clase.\n\n"
        f"**Conexión con el programa:** {prepares_for}"
    )
    return [
        md(source)
    ]


def closing(learned: list[str], next_class: str, track_bridge: str):
    learned_md = "\n".join(f"- {item}" for item in learned)
    source = (
        "---\n\n"
        "## Síntesis de la clase\n\n"
        f"{learned_md}\n\n"
        "## Comprobación conceptual\n\n"
        "Antes de continuar, intentá responder sin mirar el notebook:\n\n"
        "1. ¿Cuál era el problema central de la clase?\n"
        "2. ¿Qué entrada recibió el sistema y qué salida produjo?\n"
        "3. ¿Qué decisión humana siguió siendo necesaria?\n"
        "4. ¿Qué limitación observaste en el experimento?\n\n"
        "Si podés explicarlo con tus propias palabras y justificarlo con un "
        "resultado visible, alcanzaste el objetivo introductorio.\n\n"
        "## Puente con la próxima clase\n\n"
        f"{next_class}\n\n"
        "## Conexión con los tracks\n\n"
        f"{track_bridge}\n\n"
        "La implementación profunda, el trabajo con datasets reales y las "
        "decisiones de producción se desarrollarán en los módulos "
        "especializados."
    )
    return [
        md(source)
    ]


def notebook(cells):
    return nbf.v4.new_notebook(
        cells=cells,
        metadata={
            "kernelspec": {
                "display_name": "Python 3",
                "language": "python",
                "name": "python3",
            },
            "language_info": {"name": "python", "version": "3.12"},
        },
    )

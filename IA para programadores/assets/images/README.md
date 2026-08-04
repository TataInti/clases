# Imágenes de ejemplo

Estos archivos se guardan dentro del curso para que las demostraciones no
dependan de descargar imágenes durante la clase.

| Archivo | Procedencia | Licencia / atribución |
|---|---|---|
| `china.jpg` | Dataset de ejemplo de scikit-learn; [foto original](https://www.flickr.com/photos/danielbuechele/6061409035/) | [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/), danielbuechele |
| `flower.jpg` | Dataset de ejemplo de scikit-learn; [foto original](https://www.flickr.com/photos/vultilion/6056698931/) | [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/), vultilion |
| `escena_bus_peatones.jpg` | Generada específicamente para este curso con la herramienta de generación de imágenes de OpenAI | Asset original del curso; uso educativo dentro de este material |

`china.jpg` y `flower.jpg` conservan la atribución que scikit-learn incluye en
`sklearn/datasets/images/README.txt`. `escena_bus_peatones.jpg` no representa
personas, marcas ni vehículos reales y se usa para que la salida del detector
sea visible sin depender de una fotografía externa.

El script vuelve a copiar y valida los assets desde un entorno con las
dependencias instaladas. La escena generada debe permanecer en esta carpeta:

```bash
python assets/images/create_assets.py
```

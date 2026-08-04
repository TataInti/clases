# Assets geoespaciales de la Clase 8

Estos archivos son completamente sintéticos y se distribuyen como **CC0 1.0**.
No representan una ubicación, un cultivo ni una captura satelital reales.

- `escena_multibanda.tif`: GeoTIFF de 96 × 96 píxeles, resolución de 10 m,
  cuatro bandas (`blue`, `green`, `red`, `nir`) y CRS `EPSG:32720`.
- `parcela.geojson`: un polígono de demostración expresado en el mismo CRS.
- `create_assets.py`: generador determinista y validación mínima de ambos
  archivos.

El GeoJSON conserva un miembro `crs` heredado para que GDAL/GeoPandas lo abra
en UTM durante la práctica. Para interoperabilidad estricta con RFC 7946, debe
reproyectarse a WGS 84 (`EPSG:4326`) o utilizarse un formato como GeoPackage.

Para regenerarlos:

```bash
python assets/geospatial/create_assets.py
```

# True Blue · Cumplimiento por CEDI

Tablero de **fecha comprometida vs. fecha de cierre** para la operación de última milla de
Quick Last Mile. Se carga el CSV de servicios exportado de SmartQuick y la página arma sola el
informe del día por CEDI.

👉 Publicado en: `https://<usuario>.github.io/trueblue-cumplimiento-cedi/`

## Cómo se usa

1. Abrir la página.
2. Arrastrar el CSV de **Servicios** (separado por `;`) sobre el recuadro, o hacer clic para elegirlo.
3. La página detecta sola el **día comprometido** (la fecha de servicio más frecuente del archivo).
   Se puede cambiar en el control superior.
4. Si un CEDI tuvo una novedad con el recurso y sus cierres del día siguiente se reconocen dentro
   del día, se marca ese CEDI en **«Cierres del día siguiente reconocidos por novedad del recurso»**.
   El ajuste queda visible en la tarjeta del CEDI y en la nota metodológica: nunca se esconde.
5. Botones disponibles: exportar las guías en gestión a CSV, imprimir / guardar en PDF y cargar
   otro informe.

## Reglas de negocio

| Situación | Clasificación |
| --- | --- |
| Estado `Cancelado` | Fuera del universo (no es responsabilidad de la operación) |
| Cierre con fecha del día comprometido | **En SLA** |
| Cierre con fecha posterior | **Fuera de SLA** |
| Sin registro de cierre | **Sin cierre** (abierta al corte) |
| CEDI marcado con novedad del recurso | Sus cierres del día siguiente se reconocen dentro del día, y se reportan aparte |

El indicador de **cumplimiento** mide fecha; el de **efectividad de entrega** mide guías con novedad
`Entregado`. Son dos lecturas distintas y se muestran por separado.

## Privacidad

Todo el procesamiento ocurre **en el navegador**: el CSV no se sube a ningún servidor ni queda en el
repositorio. El `.gitignore` bloquea los `*.csv` para evitar publicar datos del destinatario por error.

## Modo automático (opcional)

Si existe el archivo `data/servicios.csv` en el repositorio, la página lo carga sola al abrir, sin
necesidad de arrastrar nada. Sirve para dejar el corte diario publicado desde N8N o desde
`scripts/actualizar.sh`. Ese archivo sí quedaría publicado, así que solo debe usarse con exports
depurados de datos personales.

## Columnas que se leen

`Guia`, `Fecha`, `finalizado`, `CEDI`, `Ciudad`, `Estado`, `Recurso`, `Novedad`, `Direccion`,
`Tipo de servicio`. Los nombres se reconocen sin distinguir mayúsculas ni tildes, y el separador
(`;`, `,`, tabulación o `|`) se detecta solo.

## Publicación

```bash
bash scripts/publicar.sh          # crea el repo, sube y activa GitHub Pages
bash scripts/actualizar.sh ruta/al/Servicios.csv   # opcional: deja el corte del día publicado
```

Requiere [GitHub CLI](https://cli.github.com/) autenticado (`gh auth login`, por navegador).

---
Quick Help Courier S.A.S. · Dirección de Operaciones

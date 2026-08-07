#!/usr/bin/env bash
# Deja el corte del día publicado en modo automático (la página lo carga sola al abrir).
# Uso: bash scripts/actualizar.sh ruta/al/Servicios.csv
set -euo pipefail

ORIGEN="${1:-}"
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

[ -n "$ORIGEN" ] || { echo "Uso: bash scripts/actualizar.sh ruta/al/Servicios.csv"; exit 1; }
[ -f "$ORIGEN" ] || { echo "No existe el archivo: $ORIGEN"; exit 1; }

FILAS="$(( $(wc -l < "$ORIGEN") - 1 ))"
[ "$FILAS" -gt 0 ] || { echo "El archivo no tiene registros."; exit 1; }
head -1 "$ORIGEN" | grep -qi "finalizado" || { echo "El archivo no trae la columna 'finalizado'."; exit 1; }

mkdir -p data
cp "$ORIGEN" data/servicios.csv
echo "Copiadas $FILAS guías a data/servicios.csv"
echo "ATENCIÓN: este archivo queda publicado. Úselo solo si está depurado de datos del destinatario."
read -r -p "¿Continuar y subir? [s/N] " OK
[ "$OK" = "s" ] || [ "$OK" = "S" ] || { rm -f data/servicios.csv; echo "Cancelado."; exit 0; }

git add -f data/servicios.csv
git commit -qm "Corte $(date +%Y-%m-%d)"
git push origin main
echo "Actualizado."

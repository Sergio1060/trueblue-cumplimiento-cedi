#!/usr/bin/env bash
# Publica el tablero en GitHub Pages. Requiere GitHub CLI autenticado (gh auth login).
set -euo pipefail

REPO="${1:-trueblue-cumplimiento-cedi}"
RAIZ="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$RAIZ"

command -v gh >/dev/null || { echo "Falta GitHub CLI. Instálelo desde https://cli.github.com/"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Ejecute primero: gh auth login"; exit 1; }
[ -f index.html ] || { echo "No se encontró index.html en $RAIZ"; exit 1; }

USUARIO="$(gh api user --jq .login)"

if [ ! -d .git ]; then
  git init -q
  git branch -M main
fi
git add -A
git diff --cached --quiet || git commit -qm "Tablero de cumplimiento por CEDI (fecha comprometida vs. cierre)"

if gh repo view "$USUARIO/$REPO" >/dev/null 2>&1; then
  git remote get-url origin >/dev/null 2>&1 || git remote add origin "https://github.com/$USUARIO/$REPO.git"
  git push -u origin main
else
  gh repo create "$REPO" --public --source=. --remote=origin --push
fi

gh api -X POST "repos/$USUARIO/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || gh api -X PUT "repos/$USUARIO/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 || true

URL="https://$USUARIO.github.io/$REPO/"
echo "Publicado. La página queda en: $URL"
echo "GitHub Pages puede tardar un par de minutos en el primer despliegue."

echo -n "Verificando..."
for i in $(seq 1 20); do
  CODIGO="$(curl -s -o /dev/null -w '%{http_code}' "$URL" || true)"
  if [ "$CODIGO" = "200" ]; then echo " OK ($CODIGO)"; exit 0; fi
  echo -n "."; sleep 15
done
echo " aún no responde; revise https://github.com/$USUARIO/$REPO/settings/pages"

#!/usr/bin/env bash
# Prepara el workspace completo sin pasos manuales:
# clona citas-api y citas-web con el nombre de carpeta que espera
# docker-compose.yml, los deja en develop (donde vive la implementación)
# y crea .env desde .env.example si falta.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

API_URL="https://github.com/jorgebuitragor/citas-api-capacitacion.git"
WEB_URL="https://github.com/jorgebuitragor/citas-web-capacitacion.git"

clone_if_missing() {
  local dir="$1" url="$2"
  if [ -d "$dir/.git" ]; then
    echo "[OK] $dir ya existe, no se toca."
    return
  fi

  echo "=== Clonando $url en ./$dir ==="
  git clone "$url" "$dir"

  if git -C "$dir" show-ref --verify --quiet refs/remotes/origin/develop; then
    git -C "$dir" checkout develop
    echo "[OK] $dir en rama develop."
  fi
}

clone_if_missing "citas-api" "$API_URL"
clone_if_missing "citas-web" "$WEB_URL"

if [ ! -f ".env" ]; then
  cp .env.example .env
  echo "[OK] .env creado a partir de .env.example."
else
  echo "[OK] .env ya existe."
fi

echo
echo "Workspace listo:"
echo "  ./citas-api  -> $(git -C citas-api branch --show-current 2>/dev/null || echo '?')"
echo "  ./citas-web  -> $(git -C citas-web branch --show-current 2>/dev/null || echo '?')"
echo
echo "Siguiente paso: docker compose up -d mysql"

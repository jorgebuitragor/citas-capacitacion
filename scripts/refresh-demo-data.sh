#!/usr/bin/env bash
# Vuelve a aplicar los datos semilla de laboratorio (idempotentes) con fechas relativas a HOY:
# disponibilidad de "mañana" (V6) y usuarios/citas de prueba (V11). No borra nada.
# Requiere el contenedor fcv-citas-mysql en marcha. Ver DATOS_SEMILLA.md.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
set -a; . ./.env; set +a

CONTAINER="fcv-citas-mysql"
DB="$(docker exec "$CONTAINER" printenv MYSQL_DATABASE)"
MIGRATIONS="citas-api/src/main/resources/db/migration"

for file in V6__refresh_demo_availability.sql V11__seed_demo_users_and_appointments.sql; do
  echo "=== Aplicando $file en $DB ==="
  docker exec -i "$CONTAINER" mysql -uroot -p"$MYSQL_ROOT_PASSWORD" "$DB" < "$MIGRATIONS/$file" 2> >(grep -v "Using a password" >&2)
done
echo "[OK] Datos semilla refrescados. Cuentas y contraseña: DATOS_SEMILLA.md"

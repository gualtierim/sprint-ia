#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENAPI="$ROOT/sprintbff/src/main/resources/static/api/openapi.yaml"

if [ ! -f "$OPENAPI" ]; then
  echo "ERRORE: contratto OpenAPI non trovato: $OPENAPI" >&2
  exit 1
fi

echo "=== 1/2 Backend — generate-sources (sprintbff) ==="
cd "$ROOT/sprintbff"
if [ -x "./mvnw" ]; then
  ./mvnw generate-sources
else
  mvn generate-sources
fi

echo
echo "=== 2/2 Frontend — generate-api (sprintwcl) ==="
cd "$ROOT/sprintwcl"
npm install --no-audit --no-fund
npm run generate-api

echo
echo "Rigenerazione completata."

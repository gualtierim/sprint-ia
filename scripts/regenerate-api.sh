#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OPENAPI="$ROOT/sprintbff/src/main/resources/static/api/openapi.yaml"
BFF="$ROOT/sprintbff"

MVN_SETTINGS=()
if [ "${USER:-$(whoami)}" = "mariogualtieri" ]; then
  MANU_MVN_SETTINGS="${HOME}/.m2/settings-manu.xml"
  if [ -f "$MANU_MVN_SETTINGS" ]; then
    MVN_SETTINGS=(-s "$MANU_MVN_SETTINGS")
  else
    echo "ATTENZIONE: settings Maven non trovato: $MANU_MVN_SETTINGS" >&2
  fi
fi

if [ ! -f "$OPENAPI" ]; then
  echo "ERRORE: contratto OpenAPI non trovato: $OPENAPI" >&2
  exit 1
fi

echo "=== 1/2 Backend — generate-sources (sprintbff) ==="
cd "$BFF"
if [ -x "./mvnw" ]; then
  ./mvnw "${MVN_SETTINGS[@]}" generate-sources
else
  mvn "${MVN_SETTINGS[@]}" generate-sources
fi

echo
echo "=== 2/2 Frontend — generate-api (sprintwcl) ==="
cd "$ROOT/sprintwcl"
npm install --no-audit --no-fund
npm run generate-api

echo
echo "Rigenerazione completata."

#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BFF="$ROOT/sprintbff"
PORT="${BFF_PORT:-8080}"

MVN_SETTINGS=()
if [ -f "${HOME}/.m2/settings-manu.xml" ]; then
  MVN_SETTINGS=(-s "${HOME}/.m2/settings-manu.xml")
fi

if [ -f "$BFF/.java-version" ] && command -v jenv >/dev/null 2>&1; then
  export PATH="${HOME}/.jenv/bin:${HOME}/.jenv/shims:${PATH}"
  export JENV_VERSION="$(tr -d '[:space:]' < "$BFF/.java-version")"
  if JAVA_HOME="$(jenv javahome 2>/dev/null)"; then
    export JAVA_HOME
    export PATH="${JAVA_HOME}/bin:${PATH}"
  fi
fi

if lsof -nP -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "ERRORE: porta $PORT già in uso (BFF già avviato?)." >&2
  echo "  Health: curl -s http://localhost:${PORT}/sprintbff/actuator/health" >&2
  echo "  Per fermare: kill \$(lsof -t -iTCP:${PORT} -sTCP:LISTEN)" >&2
  exit 1
fi

cd "$BFF"
echo "=== Avvio sprintbff (codegen saltato; usa regenerate-api.sh se modifichi openapi.yaml) ==="
exec mvn "${MVN_SETTINGS[@]}" spring-boot:run -DskipTests

#!/usr/bin/env bash
if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BFF="$ROOT/sprintbff"
WCL="$ROOT/sprintwcl"

POLL_INTERVAL="${POLL_INTERVAL:-1}"

MVN_SETTINGS=()
if [ "${USER:-$(whoami)}" = "mariogualtieri" ]; then
  MANU_MVN_SETTINGS="${HOME}/.m2/settings-manu.xml"
  if [ -f "$MANU_MVN_SETTINGS" ]; then
    MVN_SETTINGS=(-s "$MANU_MVN_SETTINGS")
  else
    echo "ATTENZIONE: settings Maven non trovato: $MANU_MVN_SETTINGS" >&2
  fi
fi

# --- utilità ---

die() {
  echo "ERRORE: $*" >&2
  exit 1
}

mvn_cmd() {
  if [ -x "$BFF/mvnw" ]; then
    (cd "$BFF" && ./mvnw "${MVN_SETTINGS[@]}" "$@")
  else
    mvn "${MVN_SETTINGS[@]}" -f "$BFF/pom.xml" "$@"
  fi
}

setup_java() {
  local ver=""
  if [ -f "$BFF/.java-version" ]; then
    ver="$(tr -d '[:space:]' < "$BFF/.java-version")"
  fi

  if [ -n "$ver" ] && command -v jenv >/dev/null 2>&1; then
    export PATH="${HOME}/.jenv/bin:${HOME}/.jenv/shims:${PATH}"
    export JENV_VERSION="$ver"
    if JAVA_HOME="$(jenv javahome 2>/dev/null)" && [ -n "$JAVA_HOME" ]; then
      export JAVA_HOME
      export PATH="${JAVA_HOME}/bin:${PATH}"
      echo "Java $ver (jenv → $JAVA_HOME)"
    elif [ -d "${HOME}/.jenv/versions/${ver}" ]; then
      export JAVA_HOME="${HOME}/.jenv/versions/${ver}"
      export PATH="${JAVA_HOME}/bin:${PATH}"
      echo "Java $ver (jenv → $JAVA_HOME)"
    else
      echo "ATTENZIONE: Java $ver non trovato in jenv — uso java di sistema" >&2
    fi
  fi
  java -version 2>&1 | head -1
}

setup_node() {
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh"
    if [ -f "$WCL/.nvmrc" ]; then
      local nvm_ver
      nvm_ver="$(tr -d '[:space:]' < "$WCL/.nvmrc")"
      if ! nvm use --silent "$nvm_ver" 2>/dev/null; then
        echo "ATTENZIONE: Node $nvm_ver non installato in nvm — uso node di sistema" >&2
        echo "  Suggerimento: nvm install $nvm_ver" >&2
      fi
    fi
  fi
  node -v
}

log_stream() {
  local prefix="$1"
  while IFS= read -r line; do
    printf '[%s] %s\n' "$prefix" "$line"
  done
}

bff_source_fingerprint() {
  # Esclude interfacce *Api.java rigenerate da swagger-codegen ad ogni compile.
  find "$BFF/src/main" -type f \
    \( -name '*.java' -o -name '*.xml' -o -name '*.yaml' -o -name '*.yml' -o -name '*.properties' \) \
    ! -path '*/api/*Api.java' \
    -exec stat -f '%m %N' {} + 2>/dev/null \
    | sort \
    | shasum \
    | awk '{print $1}'
}

compile_bff() {
  local lockdir="$BFF/target/.compile.lock.d"
  while ! mkdir "$lockdir" 2>/dev/null; do
    sleep 0.2
  done
  # shellcheck disable=SC2064
  trap "rmdir '$lockdir' 2>/dev/null || true" RETURN
  mvn_cmd compile -DskipTests -q -Dswagger.codegen.skip=true
}

wait_for_bff() {
  local url="http://localhost:8080/sprintbff/actuator/health"
  local max_attempts="${BFF_START_TIMEOUT:-120}"
  echo "[dev] attesa avvio BFF…"
  local i=0
  while [ "$i" -lt "$max_attempts" ]; do
    if curl -sf "$url" >/dev/null 2>&1; then
      echo "[dev] BFF pronto"
      return 0
    fi
    sleep 1
    i=$((i + 1))
  done
  echo "ERRORE: BFF non avviato entro ${max_attempts}s" >&2
  return 1
}

watch_bff_compile() {
  local last candidate stable debounce
  debounce="${COMPILE_DEBOUNCE:-2}"
  echo "[bff-watch] monitoraggio sorgenti (poll ogni ${POLL_INTERVAL}s, debounce ${debounce}s)…"
  last="$(bff_source_fingerprint)"
  candidate=""
  stable=0
  while true; do
    local current
    current="$(bff_source_fingerprint)"
    if [ "$current" = "$last" ]; then
      candidate=""
      stable=0
    elif [ "$current" = "$candidate" ]; then
      stable=$((stable + 1))
      if [ "$stable" -ge "$debounce" ]; then
        echo "[bff-watch] modifiche rilevate — ricompilazione…"
        if compile_bff; then
          echo "[bff-watch] compile OK (Spring DevTools riavvia l'app)"
          last="$current"
        else
          echo "[bff-watch] compile fallita" >&2
        fi
        candidate=""
        stable=0
      fi
    else
      candidate="$current"
      stable=1
    fi
    sleep "$POLL_INTERVAL"
  done
}

PIDS=()

cleanup() {
  echo
  echo "Arresto processi dev…"
  if [ "${#PIDS[@]}" -gt 0 ]; then
    local pid
    for pid in "${PIDS[@]}"; do
      kill "$pid" 2>/dev/null || true
    done
    wait 2>/dev/null || true
  fi
}

trap cleanup EXIT INT TERM

# --- prerequisiti ---

[ -f "$BFF/pom.xml" ] || die "sprintbff non trovato — esegui ./scripts/clone-repos.sh"
[ -f "$WCL/package.json" ] || die "sprintwcl non trovato — esegui ./scripts/clone-repos.sh"

command -v mvn >/dev/null 2>&1 || die "mvn non trovato nel PATH"
command -v java >/dev/null 2>&1 || die "java non trovato nel PATH"
command -v node >/dev/null 2>&1 || die "node non trovato nel PATH"
command -v npm >/dev/null 2>&1 || die "npm non trovato nel PATH"

echo "=== Sprint dev (live reload) ==="
echo "  BFF  → http://localhost:8080/sprintbff  (Spring DevTools)"
echo "  WCL  → http://localhost:4200            (ng serve + proxy /api)"
echo

setup_java
setup_node
if [ "${#MVN_SETTINGS[@]}" -gt 0 ]; then
  echo "Maven settings: ${MVN_SETTINGS[1]}"
fi
echo

echo "=== Compilazione iniziale BFF ==="
mvn_cmd clean compile -DskipTests

if [ ! -d "$WCL/node_modules" ]; then
  echo "=== npm install (sprintwcl) ==="
  (cd "$WCL" && npm install --no-audit --no-fund)
fi

echo
echo "=== Avvio backend, watcher e frontend ==="
echo "Ctrl+C per terminare tutto"
echo

mvn_cmd spring-boot:run -DskipTests -Dswagger.codegen.skip=true 2>&1 | log_stream "bff" &
PIDS+=($!)

(cd "$WCL" && npm start) 2>&1 | log_stream "wcl" &
PIDS+=($!)

if wait_for_bff; then
  watch_bff_compile 2>&1 | log_stream "bff-watch" &
  PIDS+=($!)
else
  exit 1
fi

while true; do
  for pid in "${PIDS[@]}"; do
    if ! kill -0 "$pid" 2>/dev/null; then
      wait "$pid" 2>/dev/null || true
      exit 1
    fi
  done
  sleep 1
done

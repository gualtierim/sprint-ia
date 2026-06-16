#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

GITLAB_HOST="gitlab.csi.it"

REPOS=(
  "sprintbff:prodotti/sprint/sprintbff.git"
  "sprintwcl:prodotti/sprint/sprintwcl.git"
  "sprintj:prodotti/sprint/sprintj.git"
)

gitlab_url() {
  local repo_path="$1"
  if [ -n "${GITLAB_TOKEN:-}" ]; then
    echo "https://oauth2:${GITLAB_TOKEN}@${GITLAB_HOST}/${repo_path}"
  else
    echo "https://${GITLAB_HOST}/${repo_path}"
  fi
}

clean_url() {
  echo "https://${GITLAB_HOST}/$1"
}

clone_if_missing() {
  local path="$1"
  local repo_path="$2"
  local url
  url="$(gitlab_url "$repo_path")"

  if [ -d "$path/.git" ]; then
    echo "OK  $path già presente ($(git -C "$path" rev-parse --short HEAD))"
    return
  fi

  if [ -d "$path" ] && [ -n "$(ls -A "$path" 2>/dev/null)" ]; then
    echo "ERR $path esiste ma non è un repository git — rimuovi la cartella o clona manualmente"
    exit 1
  fi

  echo "CLONE $path ← $(clean_url "$repo_path")"
  git clone "$url" "$path"
}

if [ -z "${GITLAB_TOKEN:-}" ]; then
  echo "Suggerimento: esporta GITLAB_TOKEN con un Personal Access Token GitLab"
  echo "  export GITLAB_TOKEN=glpat-..."
  echo
fi

echo "Clone repository Sprint in $ROOT"
echo

for entry in "${REPOS[@]}"; do
  path="${entry%%:*}"
  repo_path="${entry#*:}"
  clone_if_missing "$path" "$repo_path"
done

echo
echo "Repository pronti:"
for entry in "${REPOS[@]}"; do
  path="${entry%%:*}"
  printf "  %-10s %s\n" "$path" "$(git -C "$path" status -sb | head -1)"
done

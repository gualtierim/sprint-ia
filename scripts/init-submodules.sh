#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

GITLAB_HOST="gitlab.csi.it"

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

add_if_missing() {
  local path="$1"
  local repo_path="$2"
  local url
  url="$(gitlab_url "$repo_path")"

  if [ -d "$path/.git" ] || [ -f "$path/.git" ]; then
    echo "OK  $path già presente"
    return
  fi

  echo "ADD $path ← $(clean_url "$repo_path")"
  git submodule add --force "$url" "$path"
  git config -f .gitmodules "submodule.${path}.url" "$(clean_url "$repo_path")"
  git config "submodule.${path}.url" "$(clean_url "$repo_path")"
}

if [ -f .gitmodules ] && git submodule status 2>/dev/null | grep -q .; then
  echo "Inizializzazione submodule esistenti..."
  if [ -n "${GITLAB_TOKEN:-}" ]; then
    git -c "url.https://oauth2:${GITLAB_TOKEN}@${GITLAB_HOST}/.insteadOf=https://${GITLAB_HOST}/" \
      submodule update --init --recursive
  else
    git submodule update --init --recursive
  fi
else
  if [ -z "${GITLAB_TOKEN:-}" ]; then
    echo "Suggerimento: esporta GITLAB_TOKEN con un Personal Access Token GitLab"
    echo "  export GITLAB_TOKEN=glpat-..."
    echo
  fi
  echo "Prima configurazione submodule..."
  add_if_missing sprintbff prodotti/sprint/sprintbff.git
  add_if_missing sprintwcl prodotti/sprint/sprintwcl.git
  add_if_missing sprintj prodotti/sprint/sprintj.git
fi

echo
echo "Submodule configurati:"
git submodule status

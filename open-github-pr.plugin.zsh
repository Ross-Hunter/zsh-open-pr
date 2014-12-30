#!/bin/zsh
set -eo pipefail

_get_repo() {
  echo "$1" | sed -e "s/.*github.com[:/]\(.*\)\.git.*/\1/"
}

open-pr() {
  local upstream=$(git config --get remote.upstream.url)
  local origin=$(git config --get remote.origin.url)
  local branch=$(git symbolic-ref --short HEAD)
  local repo=$(get_repo "$origin")
  local pr_url="https://github.com/$repo/pull/new"

  if [[ -z $upstream ]]; then
    url="$pr_url/$branch"
  else
    target=$( [[ -z "$1" ]] && echo "master" || echo "$1" )
    origin_name=$(echo "$repo" | cut -f1 -d'/')
    upstream_name=$(get_repo "$upstream" | cut -f1 -d'/')
    url="$pr_url/$upstream_name:$target...$origin_name:$branch"
  fi
  open "$url" 2> /dev/null || xdg-open "$url" &> /dev/null
}

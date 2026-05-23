#!/usr/bin/env bash

git-clean-worktree-branches() {
  local prefix="${1:-}"

  # Get branches currently checked out in a worktree
  local worktree_branches
  worktree_branches=$(git worktree list --porcelain | awk '/^branch/ {sub("refs/heads/", "", $2); print $2}')

  # Get all local branches not in a worktree, not main/master, matching optional prefix
  local orphaned=()
  while IFS= read -r branch; do
    branch="${branch//\* /}"
    branch="${branch// /}"

    [[ "$branch" == "main" || "$branch" == "master" ]] && continue
    [[ -n "$prefix" && "$branch" != "$prefix"* ]] && continue
    grep -qx "$branch" <<< "$worktree_branches" && continue

    orphaned+=("$branch")
  done < <(git branch --format='%(refname:short)')

  if [[ ${#orphaned[@]} -eq 0 ]]; then
    echo "No orphaned branches found${prefix:+ matching prefix \"$prefix\"}."
    return 0
  fi

  echo "Branches not attached to any worktree${prefix:+ matching prefix \"$prefix\"}:"
  printf '  %s\n' "${orphaned[@]}"
  echo

  # --- First prompt: optional prefix filter ---
  read "reply?Filter by prefix (or press enter for all): "

  if [[ -n "$reply" ]]; then
    prefix="$reply"
    local filtered=()
    for branch in "${orphaned[@]}"; do
      [[ "$branch" == "$prefix"* ]] && filtered+=("$branch")
    done

    if [[ ${#filtered[@]} -eq 0 ]]; then
      echo "No orphaned branches matching prefix \"$prefix\"."
      return 0
    fi

    orphaned=("${filtered[@]}")
  fi

  # --- Second confirmation: show final list, require "yes" ---
  echo
  echo "Branches to delete${prefix:+ matching \"$prefix\"}:"
  printf '  %s\n' "${orphaned[@]}"
  echo
  read "reply2?Type 'yes' to confirm deletion: "
  [[ "$reply2" != "yes" ]] && { echo "Aborted."; return 0; }

  # --- Delete ---
  for branch in "${orphaned[@]}"; do
    git branch -D "$branch" && echo "Deleted: $branch"
  done
}
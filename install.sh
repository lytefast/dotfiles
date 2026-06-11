#!/usr/bin/env bash
set -e

dotfiles_dir=~/code/dotfiles

# Existing config files are moved here (preserving their relative paths) before
# being replaced by symlinks. Created lazily, only if something needs backing up.
backup_dir="$PWD/dotfiles_install_$(date +%Y%m%d_%H%M%S)_bk"

# Symlink a dotfile (or every file in a directory) from this repo into ~.
#
# Usage:
#   set_and_backup_file <directory> <filename>   # symlink a single file
#   set_and_backup_file <directory>              # symlink each file in the dir
#
#   directory  Path relative to ~ (and to $dotfiles_dir) where the file lives.
#              Pass "" for files that sit directly in ~. When non-empty, the
#              directory is created under ~ if it doesn't already exist.
#   filename   Name of the file to symlink. Omit to symlink every file found
#              under $dotfiles_dir/<directory> recursively, preserving the
#              subdirectory structure.
#
# Behavior:
#   - If a real file already exists at the destination, it is moved into
#     $backup_dir (preserving its relative path) so the existing config is
#     preserved rather than clobbered.
#   - Symlinks $dotfiles_dir/<path> to ~/<path> (-f overwrites a stale symlink).
#
# Examples:
#   set_and_backup_file "" .vimrc          # ~/.vimrc -> $dotfiles_dir/.vimrc
#   set_and_backup_file .config/mpv mpv.conf  # ~/.config/mpv/mpv.conf -> repo copy
#   set_and_backup_file .config             # symlink every file under .config
set_and_backup_file() {
  local directory=$1
  local filename=$2

  # Directory-only form: recursively symlink every file under the directory,
  # preserving its subdirectory structure (e.g. .config -> ~/.config/**).
  if [[ -n "$directory" && -z "$filename" ]]; then
    local f rel
    while IFS= read -r f; do
      rel=${f#"$dotfiles_dir/"}
      set_and_backup_file "$(dirname "$rel")" "$(basename "$rel")"
    done < <(find "$dotfiles_dir/$directory" -type f)
    return
  fi

  if [[ ! -z "$directory" ]]; then
    mkdir -p ~/$directory
    filename=$directory/$filename
  fi

  if test -f ~/$filename; then
    mkdir -p "$backup_dir/$(dirname "$filename")"
    mv ~/$filename "$backup_dir/$filename"
    echo "~/$filename backed up to $backup_dir/$filename"
  fi
  ln -sf $dotfiles_dir/$filename ~/$filename

  echo "~/$filename symlinked"
}

echo '== Symlinking files in' $dotfiles_dir ' =='

# Symlink config files
set_and_backup_file "" .dev_env_rc
set_and_backup_file "" .samrc
set_and_backup_file "" .git-clean-worktree-branches.sh
set_and_backup_file "" .gitconfig
set_and_backup_file "" .vimrc

set_and_backup_file "" .agents

set_and_backup_file .config

# Setup tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
set_and_backup_file "" .tmux.conf

echo '== Setup zsh =='
echo 'see https://github.com/lytefast/prezto'

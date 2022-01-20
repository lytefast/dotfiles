#!/usr/bin/env bash
set -e

dotfiles_dir=~/code/dotfiles

set_and_backup_file() {
  local filename=$1
  if test -f ~/$filename; then
    mv ~/$filename ~/$filename.bk
    echo "$filename.bk created"
  fi
  ln -sf $dotfiles_dir/$filename ~/$filename
}

echo '== Symlinking file in' $dotfiles_dir ' =='

# Symlink config files
set_and_backup_file .dev_env_rc
set_and_backup_file .samrc
set_and_backup_file .gitconfig
set_and_backup_file .mplayer
set_and_backup_file .vimrc

set_and_backup_file .config/Code/User/keybindings.json
set_and_backup_file .config/Code/User/settings.json

set_and_backup_file .config/mpv/mpv.conf

echo '== Setup zsh =='
echo 'see https://github.com/lytefast/prezto'

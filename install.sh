#!/usr/bin/env bash
set -e

dotfiles_dir=~/code/dotfiles

echo '== Symlinking file in' $dotfiles_dir ' =='

# Symlink config files
mv ~/.dev_env_rc ~/.dev_env_rc.bk
ln -sf $dotfiles_dir/.dev_env_rc ~/.dev_env_rc

mv ~/.samrc ~/.samrc.bk
ln -sf $dotfiles_dir/.samrc ~/.samrc

mv ~/.gitconfig ~/.gitconfig.bk
ln -sf $dotfiles_dir/.gitconfig ~/.gitconfig

ln -sf $dotfiles_dir/.mplayer ~/.mplayer
ln -sf $dotfiles_dir/.vimrc ~/.vimrc
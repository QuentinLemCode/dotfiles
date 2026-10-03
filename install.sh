#!/usr/bin/env bash
# Bootstrap d'une nouvelle machine :
#   GITHUB_USER=ton-user bash -c "$(curl -fsSL https://raw.githubusercontent.com/ton-user/dotfiles/main/install.sh)"
# (dépôt public requis pour le curl ; sinon : installer chezmoi puis `chezmoi init --apply git@github.com:ton-user/dotfiles.git`)
set -euo pipefail

: "${GITHUB_USER:?Définis GITHUB_USER (ex: GITHUB_USER=quentin bash install.sh)}"

sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply "$GITHUB_USER"

echo
echo "Terminé. Ouvre un nouvel onglet iTerm2 (police : MesloLGS Nerd Font) puis lance : atuin login"

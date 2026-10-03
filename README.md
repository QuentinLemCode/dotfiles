# dotfiles

Config terminal (zsh) pour macOS, gérée avec [chezmoi](https://www.chezmoi.io/).

**Contenu** : oh-my-zsh (+ autosuggestions, syntax-highlighting), starship, atuin, zoxide, fzf, lsd, bat, iTerm2 + Nerd Font.

## Structure

| Fichier du dépôt | Déployé vers | Rôle |
|---|---|---|
| `dot_zshrc.tmpl` | `~/.zshrc` | Config zsh (template chezmoi) |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Prompt |
| `dot_config/atuin/config.toml` | `~/.config/atuin/config.toml` | Historique (config seulement) |
| `dot_config/bat/config` | `~/.config/bat/config` | Thème / style de bat |
| `dot_config/lsd/config.yaml` | `~/.config/lsd/config.yaml` | Icônes / colonnes de lsd |
| `.chezmoiexternal.toml` | `~/.oh-my-zsh/...` | oh-my-zsh + plugins (téléchargés, rafraîchis chaque semaine) |
| `.chezmoiscripts/run_onchange_before_10-install-packages.sh.tmpl` | (script) | Installe Homebrew si besoin, puis `brew bundle` quand le `Brewfile` change |
| `Brewfile` | (non déployé) | Liste des paquets Homebrew / casks |
| `.chezmoiignore` | (non déployé) | Exclut README, install.sh, Brewfile du déploiement |
| `install.sh` | (non déployé) | Bootstrap d'une nouvelle machine |

## Mise en place initiale (première machine)

1. Crée un repo GitHub nommé **`dotfiles`** (vide).
2. Sauvegarde l'existant :
   ```sh
   cp ~/.zshrc ~/.zshrc.bak 2>/dev/null
   [ -d ~/.oh-my-zsh ] && mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
   ```
3. Installe chezmoi et initialise son dossier source avec ton repo :
   ```sh
   brew install chezmoi          # ou : sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
   chezmoi init git@github.com:<ton-user>/dotfiles.git
   ```
4. Copie le contenu de ce dossier dans `~/.local/share/chezmoi` (sans `.git`), puis pousse :
   ```sh
   cd ~/.local/share/chezmoi        # ou : chezmoi cd
   git add -A && git commit -m "Initial terminal config" && git push -u origin main
   ```
5. Vérifie puis applique :
   ```sh
   chezmoi diff        # aperçu
   chezmoi apply -v
   ```
6. Étapes manuelles : iTerm2 → Settings → Profiles → Text → police **MesloLGS Nerd Font**, puis `atuin login` (ou `atuin register`) et `atuin import auto`.

## Nouvelle machine

```sh
GITHUB_USER=<ton-user> bash -c "$(curl -fsSL https://raw.githubusercontent.com/<ton-user>/dotfiles/main/install.sh)"
```
(repo public requis pour le `curl`. En privé : installe chezmoi puis `chezmoi init --apply git@github.com:<ton-user>/dotfiles.git`.)

Ensuite : police iTerm2 + `atuin login --username <u>` (la clé de chiffrement se récupère avec `atuin key` sur une machine déjà configurée).

## Usage au quotidien

```sh
chezmoi edit ~/.zshrc     # édite la source (pas le fichier déployé)
chezmoi diff              # ce qui changerait
chezmoi apply             # déploie
chezmoi cd                # ouvre un shell dans le dépôt, puis git commit/push
chezmoi update            # git pull + apply (sur les autres machines)
```

Alias fourni : `cz` = `chezmoi`.

## Bonnes pratiques

- **Secrets** : jamais dans le dépôt. Mets tokens et variables sensibles dans `~/.zshrc.local` (sourcé s'il existe, non versionné).
- **Atuin** : le dépôt contient la config, jamais la clé ni la session (`~/.local/share/atuin`).
- **Ajouter un paquet** : édite `Brewfile` ; `chezmoi apply` relance `brew bundle` automatiquement.
- **Mesurer le démarrage** : décommente `zmodload zsh/zprof` en haut du `.zshrc`, ajoute `zprof` à la fin, ouvre un nouveau shell.
- **Différences entre machines** : utilise les templates chezmoi (`{{ if eq .chezmoi.hostname "..." }}`).

# ⚡ dotfiles

A minimal, blazingly fast, and completely automated macOS terminal environment.

## ✨ Features

- **Automated Bootstrap:** A single command sets up a fresh Mac from scratch.
- **Lightning Fast Shell:** Zsh optimized with lazy-loading and 24-hour completion caching.
- **Modern CLI Tools:** `eza`, `fzf`, `zoxide`, `bat`, `ripgrep`.
- **Beautiful Prompts:** 12 built-in Starship presets (swap on the fly with the `style` command).
- **Premium Terminal:** Ghostty terminal with `Maple Mono NF` fonts and dynamic syntax themes.

## 🚀 Installation

On a completely fresh Mac, just paste this single command into your terminal:

```bash
curl -sL https://raw.githubusercontent.com/lohit-dev/.config_for_mac/main/install.sh | bash
```

The script will automatically install Apple Developer Tools (if missing), clone this repository to `~/.config`, and bootstrap your entire environment (Homebrew, GUI Apps, Runtimes, and Shell configurations).

### Manual Installation

If you already have the repository cloned:

```bash
cd ~/.config
./install.sh
```

*Options:* `./install.sh --skip-casks` or `--skip-runtimes`

## 🛠️ Tooling

| Category | Tools |
| :--- | :--- |
| **Shell** | Zsh, Zinit, Starship |
| **Editor** | Neovim (NvChad) |
| **Terminal** | Ghostty, Tmux, Zellij |
| **Runtimes** | Node (nvm), Rust, Python (uv), Go, Deno, Bun, Foundry |

## 🎨 Custom Commands

Once installed, use these built-in utilities:
- `style` - Interactively change your Starship prompt preset.
- `syntax-theme` - Interactively change your Zsh syntax highlighting colors.

---
*Note: Personal files like `~/.gitconfig`, `~/.ssh/`, and GUI app settings are intentionally excluded from this repository.*

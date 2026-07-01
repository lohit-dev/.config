#!/usr/bin/env bash
# ================================================================
# ~/.config dotfiles install script
# ================================================================
# Bootstraps a fresh macOS machine with all tools, runtimes, and
# shell configuration used by this dotfiles repo.
#
# Prerequisites: Xcode Command Line Tools (xcode-select --install)
# Usage:         ./install.sh [--skip-casks] [--skip-runtimes]
# ================================================================

set -euo pipefail

# ── Colours ──────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()  { printf "${CYAN}==>${NC} ${BOLD}%s${NC}\n" "$*"; }
ok()    { printf "${GREEN} ✓${NC}  %s\n" "$*"; }
warn()  { printf "${YELLOW} ⚠${NC}  %s\n" "$*"; }
fail()  { printf "${RED} ✗${NC}  %s\n" "$*"; }

# ── Self-Bootstrapping (For fresh Macs) ──────────────────────────
if [[ ! -d "$HOME/.config/.git" ]]; then
    info "Dotfiles repository not found at ~/.config"
    
    # 1. Ensure git is installed (triggers Xcode CLI tools prompt if missing)
    if ! xcode-select -p &>/dev/null; then
        warn "Xcode Command Line Tools are missing."
        info "Triggering installation..."
        xcode-select --install
        fail "Please click 'Install' on the popup window. Once it finishes, run this script again!"
        exit 1
    fi
    
    # 2. Clone the repository
    info "Cloning dotfiles repository into ~/.config..."
    mkdir -p "$HOME/.config"
    # Ensure it's empty before cloning
    if [[ "$(ls -A "$HOME/.config")" ]]; then
        warn "~/.config is not empty. Moving contents to ~/.config.bak"
        mv "$HOME/.config" "$HOME/.config.bak"
    fi
    git clone --recursive https://github.com/lohit-dev/.config.git "$HOME/.config"
    
    # 3. Transfer execution to the cloned repo
    info "Repository cloned successfully! Launching installer..."
    cd "$HOME/.config"
    exec ./install.sh "$@"
fi

# ── Flags ────────────────────────────────────────────────────────
SKIP_CASKS=false
SKIP_RUNTIMES=false
for arg in "$@"; do
    case "$arg" in
        --skip-casks)    SKIP_CASKS=true ;;
        --skip-runtimes) SKIP_RUNTIMES=true ;;
        --help|-h)
            echo "Usage: ./install.sh [--skip-casks] [--skip-runtimes]"
            echo "  --skip-casks     Skip Homebrew cask installs (GUI apps)"
            echo "  --skip-runtimes  Skip NVM/Rust/Bun/Foundry/uv installs"
            exit 0 ;;
        *) fail "Unknown flag: $arg"; exit 1 ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSHENV="$HOME/.zshenv"

# ================================================================
# 1. Homebrew
# ================================================================
info "Checking Homebrew..."
if ! command -v brew &>/dev/null; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Ensure brew is on PATH for the rest of this script
    eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
else
    ok "Homebrew already installed"
fi

info "Updating Homebrew..."
brew update

# ================================================================
# 2. Homebrew Formulae
# ================================================================
info "Installing Homebrew formulae..."

# ── Core editor & shell ──────────────────────────────────────────
CORE=(
    neovim              # Editor
    zsh                 # Shell (macOS ships zsh but brew keeps it current)
    tmux                # Terminal multiplexer
    zellij              # Modern terminal multiplexer (Rust)
)

# ── Modern CLI replacements ──────────────────────────────────────
CLI_TOOLS=(
    eza                 # ls replacement (icons, git status)
    fzf                 # Fuzzy finder
    zoxide              # Smarter cd
    bat                 # cat replacement (syntax highlighting)
    ripgrep             # grep replacement (rg)
    fd                  # find replacement
    tree                # Directory tree viewer
    starship            # Cross-shell prompt
)

# ── Dev tools ────────────────────────────────────────────────────
DEV_TOOLS=(
    gh                  # GitHub CLI
    lazygit             # Git TUI
    thefuck             # Command correction
    shellcheck          # Shell linting
    stylua              # Lua formatter (for nvim configs)
    pandoc              # Document converter
    sqlc                # SQL -> Go code generator
    go                  # Go language
    deno                # Deno runtime
    tree-sitter-cli     # Tree-sitter grammar tooling
)

# ── Database ─────────────────────────────────────────────────────
DB=(
    postgresql@18       # PostgreSQL (zshrc auto-detects 17 or 18)
)

# ── Media & misc ─────────────────────────────────────────────────
MEDIA=(
    mpv                 # Media player
    yt-dlp              # Video downloader
    ffmpeg              # Media processing
)

# ── Security ─────────────────────────────────────────────────────
SECURITY=(
    pass                # Password manager (GPG-based)
    gnupg               # GPG encryption
)

# ── Networking ───────────────────────────────────────────────────
NETWORKING=(
    cloudflared         # Cloudflare Tunnel client
)

# ── Language support ─────────────────────────────────────────────
LANG_SUPPORT=(
    ruby                # Ruby (Homebrew-managed)
    python@3.14         # Python
)

ALL_FORMULAE=(
    "${CORE[@]}"
    "${CLI_TOOLS[@]}"
    "${DEV_TOOLS[@]}"
    "${DB[@]}"
    "${MEDIA[@]}"
    "${SECURITY[@]}"
    "${NETWORKING[@]}"
    "${LANG_SUPPORT[@]}"
)

for formula in "${ALL_FORMULAE[@]}"; do
    if brew list --formula "$formula" &>/dev/null; then
        ok "$formula (already installed)"
    else
        info "Installing $formula..."
        brew install "$formula" || warn "Failed to install $formula"
    fi
done

# ================================================================
# 3. Homebrew Casks (GUI apps)
# ================================================================
if [[ "$SKIP_CASKS" == false ]]; then
    info "Installing Homebrew casks..."

    CASKS=(
        ghostty             # Terminal emulator
        orbstack            # Docker/Linux VM manager
        bruno               # API client (Postman alternative)
        localsend           # Local file sharing
        repobar             # GitHub notifications in menu bar
        font-maple-mono-nf  # Maple Mono Nerd Font (Ghostty font)
        font-jetbrains-mono # JetBrains Mono font
    )

    for cask in "${CASKS[@]}"; do
        if brew list --cask "$cask" &>/dev/null; then
            ok "$cask (already installed)"
        else
            info "Installing $cask..."
            brew install --cask "$cask" || warn "Failed to install $cask"
        fi
    done
else
    warn "Skipping cask installs (--skip-casks)"
fi

# ================================================================
# 4. External Runtimes & Toolchains
# ================================================================
if [[ "$SKIP_RUNTIMES" == false ]]; then
    info "Installing external runtimes..."

    # ── NVM (Node Version Manager) ───────────────────────────────
    if [[ ! -d "$HOME/.nvm" ]]; then
        info "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        info "Installing latest LTS Node.js..."
        nvm install --lts
        nvm alias default lts/*
    else
        ok "NVM already installed"
    fi

    # ── Rust (rustup) ────────────────────────────────────────────
    if ! command -v rustup &>/dev/null; then
        info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # shellcheck source=/dev/null
        source "$HOME/.cargo/env"
    else
        ok "Rust already installed ($(rustup --version 2>/dev/null | head -1))"
    fi

    # ── Bun ──────────────────────────────────────────────────────
    if ! command -v bun &>/dev/null; then
        info "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash
    else
        ok "Bun already installed (v$(bun --version 2>/dev/null))"
    fi

    # ── uv (Python package manager) ─────────────────────────────
    if ! command -v uv &>/dev/null; then
        info "Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
    else
        ok "uv already installed ($(uv --version 2>/dev/null))"
    fi

    # ── Foundry (Ethereum dev toolkit) ───────────────────────────
    if ! command -v foundryup &>/dev/null; then
        info "Installing Foundry..."
        curl -L https://foundry.paradigm.xyz | bash
        export PATH="$PATH:$HOME/.foundry/bin"
        foundryup || warn "foundryup failed — run manually after restarting shell"
    else
        ok "Foundry already installed"
    fi

    # ── Ollama (already via brew, just note) ─────────────────────
    if command -v ollama &>/dev/null; then
        ok "Ollama already installed (via Homebrew)"
    fi
else
    warn "Skipping runtime installs (--skip-runtimes)"
fi

# ================================================================
# 5. Zinit (Zsh plugin manager)
# ================================================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME/.git" ]]; then
    info "Installing Zinit..."
    mkdir -p "$(dirname "$ZINIT_HOME")"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    ok "Zinit installed"
else
    ok "Zinit already installed"
fi

# ================================================================
# 6. pokemon-colorscripts (terminal eye candy)
# ================================================================
if ! command -v pokemon-colorscripts &>/dev/null; then
    info "Installing pokemon-colorscripts..."
    brew tap phoneybadger/pokemon-colorscripts
    brew install pokemon-colorscripts
    ok "pokemon-colorscripts installed"
else
    ok "pokemon-colorscripts already installed"
fi

# ================================================================
# 7. Git Submodules (NvChad config)
# ================================================================
if [[ -f "$SCRIPT_DIR/.gitmodules" ]]; then
    info "Initializing git submodules..."
    (cd "$SCRIPT_DIR" && git submodule update --init --recursive)
    ok "Submodules initialised"
fi

# ================================================================
# 8. ZDOTDIR → ~/.zshenv
# ================================================================
info "Configuring ZDOTDIR..."

ZDOTDIR_BLOCK='export ZDOTDIR="$HOME/.config/zsh"'

if [[ -f "$ZSHENV" ]]; then
    if grep -q 'ZDOTDIR' "$ZSHENV"; then
        ok "ZDOTDIR already set in $ZSHENV"
    else
        {
            echo ""
            echo "# Config repo — loads zsh from ~/.config/zsh"
            echo "$ZDOTDIR_BLOCK"
        } >> "$ZSHENV"
        ok "Appended ZDOTDIR to $ZSHENV"
    fi
else
    cat << 'EOF' > "$ZSHENV"
# ================================================================
# ZSH Configuration Directory
# ================================================================
# This MUST be first — tells zsh where to find .zshrc and other configs
export ZDOTDIR="$HOME/.config/zsh"

# ================================================================
# Environment Variables & PATH
# ================================================================

# Rust
. "$HOME/.cargo/env"

# Foundry
export PATH="$PATH:$HOME/.foundry/bin"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ruby (Homebrew)
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# Bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
EOF
    ok "Created $ZSHENV with ZDOTDIR and PATH setup"
fi

# ================================================================
# 9. Create zsh cache directory
# ================================================================
mkdir -p "$HOME/.cache/zsh/zcompcache"
ok "Ensured zsh cache directory exists"

# ================================================================
# Done!
# ================================================================
echo ""
printf "${GREEN}${BOLD}══════════════════════════════════════════${NC}\n"
printf "${GREEN}${BOLD}   ✓  Installation complete!${NC}\n"
printf "${GREEN}${BOLD}══════════════════════════════════════════${NC}\n"
echo ""
info "Next steps:"
echo "    1. Restart your shell:  exec zsh"
echo "    2. Zinit will auto-install plugins on first launch"
echo "    3. Run 'style' to switch between Starship prompt themes"
echo "    4. Run 'syntax-theme' to switch syntax highlighting colors"
echo ""
info "Installed tool quick-reference:"
echo "    Editor:       nvim (NvChad)"
echo "    Terminal:     Ghostty (Maple Mono NF, Gruvbox Dark Hard)"
echo "    Shell:        zsh + Zinit + Starship + vim mode"
echo "    Multiplexer:  tmux / zellij"
echo "    Navigation:   zoxide (cd=z), eza (ls), fzf, fd, rg, bat"
echo "    Git:          gh, lazygit (lg), gpush"
echo "    Languages:    Node (nvm), Rust, Go, Deno, Bun, Python (uv)"
echo "    Database:     PostgreSQL 18"
echo "    Blockchain:   Foundry (forge, cast, anvil)"
echo ""

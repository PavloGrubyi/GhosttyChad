#!/usr/bin/env bash
#
# GhosttyChad Installer
# A modern terminal stack for Ubuntu with Ghostty, Zsh, and friends
#
# https://github.com/PavloGrubyi/GhosttyChad
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_banner() {
    echo -e "${MAGENTA}"
    cat << 'EOF'
   ________               __  __        ________              __
  / ____/ /_  ____  _____/ /_/ /___  __/ ____/ /_  ____ _____/ /
 / / __/ __ \/ __ \/ ___/ __/ __/ / / / /   / __ \/ __ `/ __  /
/ /_/ / / / / /_/ (__  ) /_/ /_/ /_/ / /___/ / / / /_/ / /_/ /
\____/_/ /_/\____/____/\__/\__/\__, /\____/_/ /_/\__,_/\__,_/
                              /____/
EOF
    echo -e "${NC}"
    echo -e "${CYAN}Modern Terminal Stack for Ubuntu${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}==>${NC} ${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}Warning:${NC} $1"
}

print_error() {
    echo -e "${RED}Error:${NC} $1"
}

check_ubuntu() {
    if ! grep -qi "ubuntu" /etc/os-release 2>/dev/null; then
        print_warning "This script is designed for Ubuntu. Proceed with caution on other distros."
        read -p "Continue anyway? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

check_ghostty() {
    if ! command -v ghostty &> /dev/null; then
        print_error "Ghostty is not installed."
        echo ""
        echo "Please install Ghostty first:"
        echo "  https://ghostty.org/docs/install/binary#ubuntu-and-debian"
        echo ""
        exit 1
    fi
    print_step "Ghostty $(ghostty --version | head -1 | awk '{print $2}') detected"
}

install_apt_packages() {
    print_step "Installing apt packages..."

    sudo apt update
    sudo apt install -y \
        zsh \
        fzf \
        bat \
        ripgrep \
        fd-find \
        jq \
        unzip \
        unar \
        poppler-utils \
        ffmpegthumbnailer \
        imagemagick \
        gpg \
        curl \
        git
}

install_zsh_plugins() {
    print_step "Installing Zsh plugins..."

    mkdir -p ~/.zsh/plugins

    # zsh-autosuggestions
    if [ ! -d ~/.zsh/plugins/zsh-autosuggestions ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
    else
        echo "  zsh-autosuggestions already installed"
    fi

    # zsh-syntax-highlighting
    if [ ! -d ~/.zsh/plugins/zsh-syntax-highlighting ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
    else
        echo "  zsh-syntax-highlighting already installed"
    fi

    # zsh-completions
    if [ ! -d ~/.zsh/plugins/zsh-completions ]; then
        git clone https://github.com/zsh-users/zsh-completions ~/.zsh/plugins/zsh-completions
    else
        echo "  zsh-completions already installed"
    fi
}

install_starship() {
    print_step "Installing Starship prompt..."

    if command -v starship &> /dev/null; then
        echo "  Starship already installed"
    else
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi
}

install_zoxide() {
    print_step "Installing Zoxide..."

    if command -v zoxide &> /dev/null; then
        echo "  Zoxide already installed"
    else
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
}

install_eza() {
    print_step "Installing eza..."

    if command -v eza &> /dev/null; then
        echo "  eza already installed"
    else
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
    fi
}

install_yazi() {
    print_step "Installing Yazi file manager..."

    if command -v yazi &> /dev/null; then
        echo "  Yazi already installed"
    else
        # Check for cargo
        if ! command -v cargo &> /dev/null; then
            print_step "Installing Rust (required for Yazi)..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
        cargo install yazi-fm yazi-cli
    fi
}

install_nerd_font() {
    print_step "Checking for Nerd Font..."

    if fc-list | grep -qi "JetBrainsMono Nerd"; then
        echo "  JetBrainsMono Nerd Font already installed"
    else
        print_step "Installing JetBrainsMono Nerd Font..."
        mkdir -p ~/.local/share/fonts
        cd /tmp
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
        unzip -o -q JetBrainsMono.zip -d JetBrainsMono
        cp JetBrainsMono/*.ttf ~/.local/share/fonts/
        fc-cache -fv
        rm -rf JetBrainsMono JetBrainsMono.zip
    fi
}

backup_configs() {
    print_step "Backing up existing configs..."

    local backup_dir=~/.config/ghosttychad-backup-$(date +%Y%m%d-%H%M%S)
    mkdir -p "$backup_dir"

    [ -f ~/.zshrc ] && cp ~/.zshrc "$backup_dir/"
    [ -f ~/.config/ghostty/config ] && cp ~/.config/ghostty/config "$backup_dir/"
    [ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$backup_dir/"
    [ -d ~/.config/yazi ] && cp -r ~/.config/yazi "$backup_dir/"

    echo "  Backup saved to $backup_dir"
}

install_configs() {
    print_step "Installing config files..."

    # Ghostty
    mkdir -p ~/.config/ghostty
    cp "$SCRIPT_DIR/configs/ghostty.config" ~/.config/ghostty/config

    # Starship
    mkdir -p ~/.config
    cp "$SCRIPT_DIR/configs/starship.toml" ~/.config/starship.toml

    # Yazi
    mkdir -p ~/.config/yazi
    cp "$SCRIPT_DIR/configs/yazi.toml" ~/.config/yazi/yazi.toml

    # Zshrc - preserve existing integrations
    if [ -f ~/.zshrc ]; then
        # Extract any existing integrations to preserve
        local preserved=""
        if grep -q "kiro" ~/.zshrc 2>/dev/null; then
            preserved=$(grep -E "(kiro|TERM_PROGRAM)" ~/.zshrc)
        fi

        # Copy new zshrc
        cp "$SCRIPT_DIR/configs/zshrc" ~/.zshrc

        # Add preserved integrations at the top if any
        if [ -n "$preserved" ]; then
            local tmpfile=$(mktemp)
            echo "# Preserved integrations" > "$tmpfile"
            echo "$preserved" >> "$tmpfile"
            echo "" >> "$tmpfile"
            cat ~/.zshrc >> "$tmpfile"
            mv "$tmpfile" ~/.zshrc
        fi
    else
        cp "$SCRIPT_DIR/configs/zshrc" ~/.zshrc
    fi
}

set_default_shell() {
    print_step "Setting Zsh as default shell..."

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        echo "  Default shell changed to Zsh"
    else
        echo "  Zsh is already the default shell"
    fi
}

print_success() {
    echo ""
    echo -e "${GREEN}============================================${NC}"
    echo -e "${GREEN}  GhosttyChad installation complete!${NC}"
    echo -e "${GREEN}============================================${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Close and reopen Ghostty"
    echo "  2. Enjoy your new terminal!"
    echo ""
    echo "Keybindings (Chrome-like):"
    echo "  Ctrl+T        New tab"
    echo "  Ctrl+W        Close tab/split"
    echo "  Ctrl+N        New window"
    echo "  F11           Fullscreen"
    echo "  Ctrl+\\        Split right"
    echo "  Ctrl+Shift+\\  Split down"
    echo "  Ctrl+F        Search files (fzf)"
    echo "  Ctrl+R        Search history"
    echo ""
    echo -e "Config locations:"
    echo "  ~/.config/ghostty/config"
    echo "  ~/.config/starship.toml"
    echo "  ~/.config/yazi/yazi.toml"
    echo "  ~/.zshrc"
    echo ""
}

# Main
main() {
    print_banner
    check_ubuntu
    check_ghostty

    echo ""
    read -p "This will install GhosttyChad. Continue? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        exit 0
    fi
    echo ""

    backup_configs
    install_apt_packages
    install_nerd_font
    install_zsh_plugins
    install_starship
    install_zoxide
    install_eza
    install_yazi
    install_configs
    set_default_shell

    print_success
}

main "$@"

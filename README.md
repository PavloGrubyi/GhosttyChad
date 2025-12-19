# GhosttyChad

A modern, opinionated terminal stack for Ubuntu featuring [Ghostty](https://ghostty.org), Zsh with Fish-like features, and a beautiful Catppuccin theme.
<table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td><img src="https://github.com/user-attachments/assets/b5141122-f9e4-4364-b325-867093eb3a9a" width="100%"></td>
      <td><img src="https://github.com/user-attachments/assets/548031e9-61e4-4ca1-9196-6fe6dba55ba7" width="100%"></td>
    </tr>
  </table>




![Catppuccin Mocha Theme](https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/palette/macchiato.png)

## What's Included

| Component | Description |
|-----------|-------------|
| [Ghostty](https://ghostty.org) | Fast, GPU-accelerated terminal emulator |
| [Zsh](https://www.zsh.org/) | Powerful shell with Fish-like features |
| [Starship](https://starship.rs/) | Minimal, fast, customizable prompt |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for files and history |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter cd command |
| [eza](https://github.com/eza-community/eza) | Modern ls replacement |
| [bat](https://github.com/sharkdp/bat) | cat with syntax highlighting |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager |
| [JetBrainsMono Nerd Font](https://www.nerdfonts.com/) | Programming font with icons |

## Features

- **Chrome-like keybindings** - `Ctrl+T` for new tab, `Ctrl+W` to close, `Ctrl+N` for new window
- **Fish-like autosuggestions** - Type and see suggestions from history
- **Syntax highlighting** - Commands are highlighted as you type
- **Fuzzy finding** - `Ctrl+F` to search files, `Ctrl+R` for history
- **Smart directory jumping** - Use `z` to jump to frequent directories
- **Beautiful theme** - Catppuccin Mocha everywhere

## Prerequisites

- Ubuntu 22.04+ (may work on other Debian-based distros)

## Installation

```bash
git clone https://github.com/PavloGrubyi/GhosttyChad.git
cd GhosttyChad
./install.sh
```

Then close and reopen Ghostty.

## Keybindings

### Ghostty (Terminal)

| Action | Keybind |
|--------|---------|
| New tab | `Ctrl+T` |
| Close tab/split | `Ctrl+W` |
| Next/Prev tab | `Ctrl+Tab` / `Ctrl+Shift+Tab` |
| Move tab | `Ctrl+Shift+Alt+Left/Right` |
| New window | `Ctrl+N` |
| Fullscreen | `F11` |
| Split right | `Ctrl+\` |
| Split down | `Ctrl+Shift+\` |
| Navigate splits | `Alt+Arrow` or `Ctrl+Shift+H/J/K/L` |
| Zoom split | `Ctrl+Shift+Z` |
| Equalize splits | `Ctrl+Shift+=` |
| Jump to prompt | `Ctrl+Shift+Up/Down` |
| Font size | `Ctrl++` / `Ctrl+-` / `Ctrl+0` |
| Reload config | `Ctrl+Shift+R` |

### Shell (Zsh)

| Action | Keybind |
|--------|---------|
| Accept autosuggestion | `Right Arrow` |
| Search files (fzf) | `Ctrl+F` |
| Search history (fzf) | `Ctrl+R` |
| cd to directory (fzf) | `Alt+C` |
| Word forward/back | `Ctrl+Right/Left` |

## CLI Commands

| Command | Description |
|---------|-------------|
| `z <dir>` | Smart cd (learns frequent paths) |
| `zi` | Interactive directory picker |
| `y` or `yazi` | File manager |
| `yy` | Yazi with cd on exit |
| `ll` | Detailed list (eza) |
| `lt` | Tree view |
| `cat <file>` | Syntax highlighted (bat) |
| `mkcd <dir>` | Create directory and cd into it |

## Configuration Files

After installation, configs are located at:

```
~/.config/ghostty/config    # Terminal
~/.config/starship.toml     # Prompt
~/.config/yazi/yazi.toml    # File manager
~/.zshrc                    # Shell
```

Quick edit aliases:
```bash
ghosttyrc   # Edit Ghostty config
zshrc       # Edit Zsh config
```

## Customization

### Change Theme

Ghostty supports many themes. List available themes:
```bash
ghostty +list-themes
```

Edit `~/.config/ghostty/config` and change the theme line:
```
theme = dark:Dracula,light:GitHub Light
```

### Change Font Size

Edit `~/.config/ghostty/config`:
```
font-size = 14
```

Or use `Ctrl++` / `Ctrl+-` to adjust on the fly.

## Uninstall

The installer creates a backup before making changes. To restore:

1. Find your backup: `ls ~/.config/ghosttychad-backup-*`
2. Restore files from the backup directory
3. Change shell back: `chsh -s /bin/bash`

## Troubleshooting

### Ctrl+T doesn't work for new tab
Make sure you restarted Ghostty after installation. Press `Ctrl+Shift+R` to reload config.

### Ctrl+F doesn't open file search
Open a new tab or run `source ~/.zshrc` to reload shell config.

### Icons not showing
Make sure JetBrainsMono Nerd Font is installed and Ghostty is using it.

## Credits

- [Ghostty](https://ghostty.org) by Mitchell Hashimoto
- [Catppuccin](https://github.com/catppuccin/catppuccin) theme
- [Starship](https://starship.rs) prompt
- All the amazing open source tools included

## License

MIT

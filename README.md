# Dotfiles Repository

A professional Ubuntu terminal configuration backup including shell settings, Oh My Posh themes, and Nerd Fonts.

## Contents

- **shell/** - Bash configuration files (.bashrc)
- **themes/** - Oh My Posh theme configurations (cobalt2.omp.json)
- **fonts/** - Nerd Font collections (FiraCode, MesloLGS variants)
- **scripts/** - Custom utility scripts
- **install.sh** - Automated setup script
- **packages.txt** - Essential Ubuntu packages to install

## Quick Start

### Prerequisites

- Ubuntu/Debian-based system
- `curl` installed
- `sudo` access

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installation script:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Reload your shell:**
   ```bash
   source ~/.bashrc
   ```

4. **Set terminal font:**
   - Open GNOME Terminal Preferences
   - Set font to: **FiraCode Nerd Font Semi-Bold 12**

### What Gets Installed

The `install.sh` script will:

✅ Install Oh My Posh  
✅ Install packages from `packages.txt`  
✅ Copy `.bashrc` to `~/.bashrc` (with backup)  
✅ Install Oh My Posh theme to `~/.config/oh-my-posh/`  
✅ Copy Nerd Fonts to `~/.local/share/fonts/`  
✅ Refresh font cache  

## Customization

### Edit Bash Configuration
```bash
vim ~/.bashrc
source ~/.bashrc
```

### Change Oh My Posh Theme
Edit the theme file:
```bash
vim ~/.config/oh-my-posh/cobalt2.omp.json
```

### Add More Packages
Edit `packages.txt` and re-run `install.sh`:
```bash
echo "package-name" >> packages.txt
./install.sh
```

### Add Custom Scripts
Place scripts in `scripts/` directory and make them executable:
```bash
chmod +x scripts/my-script.sh
```

## File Locations After Installation

```
~/.bashrc                                  # Shell configuration
~/.config/oh-my-posh/cobalt2.omp.json     # Oh My Posh theme
~/.local/share/fonts/                     # Installed Nerd Fonts
```

## Aliases Available

**Git:**
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git pull
- `gph` - git push

**Navigation:**
- `dwn` - ~/Downloads
- `desk` - ~/Desktop
- `work` - ~/Desktop/work

**MySQL:**
- `connectdb` - mysql -u lemma -p

**Utilities:**
- `ll` - ls -alF
- `la` - ls -A
- `showalias` - Display all aliases

## Restoring Backups

If anything goes wrong, the original `.bashrc` is backed up:
```bash
# Restore backup (replace TIMESTAMP with actual value)
cp ~/.bashrc.backup.TIMESTAMP ~/.bashrc
```

## Reverting Installation

If you want to remove all changes made by the installation script:

```bash
chmod +x revert.sh
./revert.sh
```

The revert script will:
- ✅ Remove Oh My Posh
- ✅ Restore your original `.bashrc` from backup
- ✅ Remove Oh My Posh theme configuration
- ✅ Remove installed Nerd Fonts
- ✅ Optionally remove installed packages

**Note:** The script will ask for confirmation before proceeding and will offer to remove packages optionally.

## Theme Customization

The Cobalt2 theme includes:
- Green terminal text on black background
- FiraCode Nerd Font for glyphs
- Custom git status indicators
- Color-coded command prompts

Edit `themes/cobalt2.omp.json` for custom styling.

## Troubleshooting

### Oh My Posh not loading
```bash
# Verify installation
which oh-my-posh
# Reinstall if needed
curl -s https://ohmyposh.dev/install.sh | bash -s
```

### Fonts not displaying correctly
```bash
# Rebuild font cache
fc-cache -f ~/.local/share/fonts

# Verify fonts installed
fc-list | grep -i nerd
```

### Aliases not working
```bash
# Ensure .bashrc is sourced
source ~/.bashrc
# Check aliases
alias | grep -E '^(gs|ga|gc)'
```

## License

MIT License - Feel free to use, modify, and share.

## Contributing

To contribute improvements, fork this repository and submit a pull request.

---

**Last Updated:** 2026
**Maintained by:** Ashish Shinde  
**Repository:** https://github.com/Aashish-Shinde/dotfiles.git

#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Dotfiles Installation Script         ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

# Check if running on Ubuntu/Debian
if ! command -v apt-get &> /dev/null; then
    echo -e "${RED}Error: This script requires apt-get (Ubuntu/Debian)${NC}"
    exit 1
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Install Oh My Posh
echo -e "\n${YELLOW}[1/5] Installing Oh My Posh...${NC}"
if ! command -v oh-my-posh &> /dev/null; then
    curl -s https://ohmyposh.dev/install.sh | bash -s
    echo -e "${GREEN}✓ Oh My Posh installed${NC}"
else
    echo -e "${GREEN}✓ Oh My Posh already installed${NC}"
fi

# Step 2: Install optional packages
echo -e "\n${YELLOW}[2/5] Installing packages from packages.txt...${NC}"
if [ -f "$SCRIPT_DIR/packages.txt" ]; then
    PACKAGES=$(grep -v '^#' "$SCRIPT_DIR/packages.txt" | grep -v '^$' | tr '\n' ' ')
    if [ -n "$PACKAGES" ]; then
        # Remove expired GPG keys to avoid update failures
        echo -e "${YELLOW}Removing expired GPG keys...${NC}"
        sudo rm -f /etc/apt/trusted.gpg.d/mysql.gpg 2>/dev/null || true
        
        # Update package lists with error tolerance
        echo -e "${YELLOW}Updating package lists...${NC}"
        sudo apt-get update 2>&1 | grep -v "EXPKEYSIG\|The following signatures were invalid" || true
        
        # Install packages
        sudo apt-get install -y $PACKAGES 2>&1 || {
            echo -e "${YELLOW}⚠ Some packages failed to install, attempting individual installation...${NC}"
            for package in $PACKAGES; do
                sudo apt-get install -y "$package" 2>/dev/null || echo -e "${YELLOW}⚠ Could not install $package${NC}"
            done
        }
        echo -e "${GREEN}✓ Packages installation completed${NC}"
    fi
else
    echo -e "${YELLOW}⚠ packages.txt not found, skipping${NC}"
fi

# Step 3: Setup .bashrc
echo -e "\n${YELLOW}[3/5] Setting up .bashrc...${NC}"
if [ -f "$SCRIPT_DIR/shell/.bashrc" ]; then
    # Backup existing .bashrc
    if [ -f ~/.bashrc ]; then
        cp ~/.bashrc ~/.bashrc.backup.$(date +%s)
        echo -e "${YELLOW}✓ Backed up existing .bashrc${NC}"
    fi
    cp "$SCRIPT_DIR/shell/.bashrc" ~/.bashrc
    echo -e "${GREEN}✓ .bashrc installed${NC}"
else
    echo -e "${RED}✗ shell/.bashrc not found${NC}"
    exit 1
fi

# Step 4: Setup Oh My Posh theme
echo -e "\n${YELLOW}[4/5] Setting up Oh My Posh theme...${NC}"
POSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh"
mkdir -p "$POSH_CONFIG_DIR"
if [ -f "$SCRIPT_DIR/themes/cobalt2.omp.json" ]; then
    cp "$SCRIPT_DIR/themes/cobalt2.omp.json" "$POSH_CONFIG_DIR/"
    echo -e "${GREEN}✓ Theme installed to $POSH_CONFIG_DIR/cobalt2.omp.json${NC}"
else
    echo -e "${RED}✗ themes/cobalt2.omp.json not found${NC}"
    exit 1
fi

# Step 5: Install Nerd Fonts
echo -e "\n${YELLOW}[5/5] Installing Nerd Fonts...${NC}"
FONTS_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONTS_DIR"

if [ -d "$SCRIPT_DIR/fonts" ]; then
    # Copy all font directories
    cp -r "$SCRIPT_DIR/fonts"/*/ "$FONTS_DIR/" 2>/dev/null || true
    
    # Rebuild font cache
    fc-cache -f "$FONTS_DIR"
    echo -e "${GREEN}✓ Fonts installed and cache refreshed${NC}"
else
    echo -e "${YELLOW}⚠ fonts directory not found, skipping${NC}"
fi

# Final steps
echo -e "\n${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Installation Complete!               ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Reload your shell: ${GREEN}source ~/.bashrc${NC}"
echo -e "2. Update the oh-my-posh config path in ~/.bashrc:"
echo -e "   ${GREEN}eval \"\$(oh-my-posh init bash --config '$POSH_CONFIG_DIR/cobalt2.omp.json')\"${NC}"
echo -e "3. Set your terminal font to: ${GREEN}FiraCode Nerd Font or MesloLGS Nerd Font${NC}"
echo -e "4. Restart your terminal\n"

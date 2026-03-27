#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${RED}╔════════════════════════════════════════╗${NC}"
echo -e "${RED}║   Dotfiles Revert Script               ║${NC}"
echo -e "${RED}╚════════════════════════════════════════╝${NC}"

# Confirmation prompt
echo -e "\n${YELLOW}⚠ This will revert all changes made by install.sh${NC}"
echo -e "${YELLOW}Continue? (yes/no):${NC}"
read -r confirm
if [ "$confirm" != "yes" ]; then
    echo -e "${GREEN}Revert cancelled${NC}"
    exit 0
fi

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 1: Remove Oh My Posh
echo -e "\n${YELLOW}[1/5] Removing Oh My Posh...${NC}"
if command -v oh-my-posh &> /dev/null; then
    rm -rf "$HOME/.local/bin/oh-my-posh" 2>/dev/null || true
    rm -rf "$HOME/.local/share/oh-my-posh" 2>/dev/null || true
    echo -e "${GREEN}✓ Oh My Posh removed${NC}"
else
    echo -e "${GREEN}✓ Oh My Posh not found${NC}"
fi

# Step 2: Restore .bashrc
echo -e "\n${YELLOW}[2/5] Restoring .bashrc...${NC}"
if [ -f ~/.bashrc.backup.* ]; then
    # Restore the most recent backup
    LATEST_BACKUP=$(ls -t ~/.bashrc.backup.* | head -n 1)
    cp "$LATEST_BACKUP" ~/.bashrc
    echo -e "${GREEN}✓ .bashrc restored from backup: $LATEST_BACKUP${NC}"
elif [ -f /etc/skel/.bashrc ]; then
    # Restore from system default
    cp /etc/skel/.bashrc ~/.bashrc
    echo -e "${GREEN}✓ .bashrc restored from system default${NC}"
else
    echo -e "${YELLOW}⚠ No .bashrc backup found. Please restore manually${NC}"
fi

# Step 3: Remove Oh My Posh theme config
echo -e "\n${YELLOW}[3/5] Removing Oh My Posh theme config...${NC}"
POSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh"
if [ -d "$POSH_CONFIG_DIR" ]; then
    rm -rf "$POSH_CONFIG_DIR"
    echo -e "${GREEN}✓ Theme config removed${NC}"
else
    echo -e "${GREEN}✓ Theme config not found${NC}"
fi

# Step 4: Remove Nerd Fonts
echo -e "\n${YELLOW}[4/5] Removing Nerd Fonts...${NC}"
FONTS_DIR="$HOME/.local/share/fonts"
if [ -d "$FONTS_DIR" ]; then
    # Remove only the fonts installed by this script
    rm -rf "$FONTS_DIR/firacode-nerd-font"* 2>/dev/null || true
    rm -rf "$FONTS_DIR/meslol"* 2>/dev/null || true
    fc-cache -f "$FONTS_DIR" 2>/dev/null || true
    echo -e "${GREEN}✓ Nerd Fonts removed${NC}"
else
    echo -e "${GREEN}✓ Fonts directory not found${NC}"
fi

# Step 5: Optional package removal
echo -e "\n${YELLOW}[5/5] Package removal${NC}"
echo -e "${YELLOW}Remove packages installed by this script? (yes/no):${NC}"
read -r remove_packages
if [ "$remove_packages" = "yes" ]; then
    PACKAGES="unzip build-essential curl wget vim nodejs golang-go fontconfig"
    echo -e "${YELLOW}Removing packages...${NC}"
    sudo apt-get remove -y $PACKAGES 2>&1 || {
        echo -e "${YELLOW}⚠ Some packages could not be removed${NC}"
    }
    echo -e "${GREEN}✓ Packages removal completed${NC}"
else
    echo -e "${GREEN}✓ Packages not removed${NC}"
fi

# Final message
echo -e "\n${RED}╔════════════════════════════════════════╗${NC}"
echo -e "${RED}║   Revert Complete!                     ║${NC}"
echo -e "${RED}╚════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Reload your shell: ${GREEN}source ~/.bashrc${NC}"
echo -e "2. Restart your terminal\n"

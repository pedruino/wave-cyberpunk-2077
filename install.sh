#!/bin/bash
# Cyberpunk 2077 Terminal Theme Installer
# Supports: Wave Terminal, iTerm2, Alacritty, VS Code

set -e

RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${MAGENTA}"
echo "  🌃 Cyberpunk 2077 Terminal Theme Installer"
echo -e "${NC}"
echo ""

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo -e "${RED}❌ Unsupported OS: $OSTYPE${NC}"
    exit 1
fi

# Install Wave Terminal theme
install_wave() {
    echo -e "${CYAN}📦 Installing Wave Terminal theme...${NC}"
    
    WAVE_CONFIG="$HOME/.config/waveterm"
    mkdir -p "$WAVE_CONFIG"
    
    cp "$SCRIPT_DIR/themes/termthemes.json" "$WAVE_CONFIG/"
    cp "$SCRIPT_DIR/themes/backgrounds.json" "$WAVE_CONFIG/"
    
    echo -e "${YELLOW}   termthemes.json → ~/.config/waveterm/${NC}"
    echo -e "${YELLOW}   backgrounds.json → ~/.config/waveterm/${NC}"
    
    # Update settings.json
    SETTINGS="$WAVE_CONFIG/settings.json"
    if [ -f "$SETTINGS" ]; then
        # Backup
        cp "$SETTINGS" "$SETTINGS.backup.$(date +%s)"
        
        # Merge or create
        if command -v python3 &> /dev/null; then
            python3 -c "
import json
with open('$SETTINGS', 'r') as f:
    data = json.load(f)
data['term:theme'] = 'cyberpunk-2077-magenta-heat'
data['tab:background'] = 'bg@magenta-heat'
data['term:fontfamily'] = 'JetBrainsMono Nerd Font'
with open('$SETTINGS', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || echo "   ⚠️  Could not auto-update settings.json"
        fi
    fi
    
    echo -e "${CYAN}✅ Wave Terminal theme installed!${NC}"
    echo ""
}

# Install iTerm2 theme
install_iterm() {
    echo -e "${CYAN}📦 Installing iTerm2 theme...${NC}"
    
    if [ "$OS" == "macos" ]; then
        open "$SCRIPT_DIR/terminals/iterm-cyberpunk-night-city.itermcolors"
        echo -e "${YELLOW}   Open iTerm2 → Preferences → Profiles → Colors → Color Presets${NC}"
        echo -e "${CYAN}✅ iTerm2 theme imported!${NC}"
    else
        echo -e "${RED}   ⚠️  iTerm2 is macOS only${NC}"
    fi
    echo ""
}

# Install Alacritty theme
install_alacritty() {
    echo -e "${CYAN}📦 Installing Alacritty theme...${NC}"
    
    ALACRITTY_CONFIG="$HOME/.config/alacritty"
    mkdir -p "$ALACRITTY_CONFIG"
    
    cp "$SCRIPT_DIR/terminals/alacritty-cyberpunk.yml" "$ALACRITTY_CONFIG/cyberpunk.yml"
    echo -e "${YELLOW}   cyberpunk.yml → ~/.config/alacritty/${NC}"
    echo -e "${YELLOW}   Add to alacritty.yml: import: [~/.config/alacritty/cyberpunk.yml]${NC}"
    echo -e "${CYAN}✅ Alacritty theme installed!${NC}"
    echo ""
}

# Install VS Code theme
install_vscode() {
    echo -e "${CYAN}📦 Installing VS Code terminal theme...${NC}"
    
    VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
    if [ "$OS" == "linux" ]; then
        VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"
    fi
    
    echo -e "${YELLOW}   Copy the contents of vscode-terminal-theme.json${NC}"
    echo -e "${YELLOW}   into your VS Code settings.json under workbench.colorCustomizations${NC}"
    echo -e "${CYAN}✅ VS Code instructions displayed!${NC}"
    echo ""
}

# Install Starship prompt
install_starship() {
    echo -e "${CYAN}📦 Installing Starship prompt...${NC}"
    
    STARSHIP_CONFIG="$HOME/.config"
    mkdir -p "$STARSHIP_CONFIG"
    
    cp "$SCRIPT_DIR/prompts/starship.toml" "$STARSHIP_CONFIG/starship.toml"
    echo -e "${YELLOW}   starship.toml → ~/.config/${NC}"
    
    # Check if starship is installed
    if ! command -v starship &> /dev/null; then
        echo -e "${YELLOW}   ⚠️  Starship not found. Install with:${NC}"
        echo -e "${YELLOW}      curl -sS https://starship.rs/install.sh | sh${NC}"
    fi
    
    echo -e "${CYAN}✅ Starship prompt installed!${NC}"
    echo ""
}

# Main menu
echo "Which terminals do you want to install the theme for?"
echo ""
echo "  1) Wave Terminal (macOS/Linux)"
echo "  2) iTerm2 (macOS)"
echo "  3) Alacritty"
echo "  4) VS Code"
echo "  5) Starship Prompt"
echo "  6) All of the above"
echo "  7) Exit"
echo ""
read -p "Enter your choice [1-7]: " choice

case $choice in
    1) install_wave ;;
    2) install_iterm ;;
    3) install_alacritty ;;
    4) install_vscode ;;
    5) install_starship ;;
    6)
        install_wave
        install_iterm
        install_alacritty
        install_vscode
        install_starship
        ;;
    7) exit 0 ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${MAGENTA}"
echo "  🎉 Installation complete!"
echo "  Restart your terminal to apply the changes."
echo -e "${NC}"

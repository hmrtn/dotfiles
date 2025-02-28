#!/bin/bash
# Get the directory where the script is located
DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="$HOME/.config"
echo "Using dotfiles from: $DOTFILES_DIR"
echo "Linking to: $CONFIG_DIR"
# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"
# Function to backup existing config
backup_config() {
    local dir="$1"
    if [ -e "$dir" ]; then
        echo "Backing up existing $dir to ${dir}.backup"
        mv "$dir" "${dir}.backup"
    fi
}
# Function to create symbolic link
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [ -L "$target" ]; then
        echo "Removing existing symlink $target"
        rm "$target"
    fi
    
    echo "Creating symlink: $target -> $source"
    ln -s "$source" "$target"
}
# Array of directories to symlink in .config
configs=(
    "kitty"
    "nvim"
    "tmux"
    "starship"
)
# Create symlinks for each config directory
for config in "${configs[@]}"; do
    source_dir="$DOTFILES_DIR/$config"
    target_dir="$CONFIG_DIR/$config"
    
    # Skip if source doesn't exist
    if [ ! -e "$source_dir" ]; then
        echo "Warning: Source directory $source_dir does not exist, skipping..."
        continue
    fi
    
    # Backup existing config if it's not a symlink
    if [ -e "$target_dir" ] && [ ! -L "$target_dir" ]; then
        backup_config "$target_dir"
    fi
    
    # Create symlink
    create_symlink "$source_dir" "$target_dir"
done
# Handle zsh configuration separately
echo "Setting up zsh configuration..."
# Create symlink for .zshrc in home directory
if [ -f "$DOTFILES_DIR/zsh/zshrc" ]; then
    if [ -e "$HOME/.zshrc" ] && [ ! -L "$HOME/.zshrc" ]; then
        backup_config "$HOME/.zshrc"
    fi
    create_symlink "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
fi
# Create symlink for zsh directory in .config
if [ -d "$DOTFILES_DIR/zsh" ]; then
    if [ -e "$CONFIG_DIR/zsh" ] && [ ! -L "$CONFIG_DIR/zsh" ]; then
        backup_config "$CONFIG_DIR/zsh"
    fi
    create_symlink "$DOTFILES_DIR/zsh" "$CONFIG_DIR/zsh"
fi

# Setup Starship configuration
echo "Setting up Starship configuration..."
STARSHIP_CONFIG_PATH="$DOTFILES_DIR/starship/starship.toml"

echo "Dotfiles setup complete!"

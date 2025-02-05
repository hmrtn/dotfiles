#!/bin/bash

DOTFILES_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="$HOME/.config" # macos 

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

# Array of directories to symlink
configs=(
    "kitty"
    "nvim"
    "tmux"
    "zsh"
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

echo "Dotfiles setup complete!"

#!/bin/bash

# Exit on Error

set -e

# Update system
echo "Updating system packages..."
sudo pacman -Syu --noconfirm || log_error "Failed to update system."

# Install git if not present
if ! command_exists git; then
    echo "Installing git..."
    sudo pacman -S git --noconfirm || log_error "Failed to install git."
fi

# Removing any current dotfiles. 
echo "Removing any dotfiles already present"
rm -rf ~/.config/nvim/
rm -rf ~/.config/alacritty/
rm -rf ~/.config/hypr/

# Clone dotfiles repository to tmp folder
echo "Cloning dotfiles from \"danielc2501@github.com/dotfiles.git\"..."
git clone https://www.github.com/danielc2501/dotfiles.git /tmp/dotfiles || log_error "Failed to clone dotfiles repository."

# Move dotfiles to their correct locations
echo "moving the dotfiles to their correct locations"
rsync -a --exclude '.git' /tmp/dotfiles/ ~/

# Cleanup
echo "Dotfiles moved successfully. Cleaning up tmp dotfiles folder"
rm -rf /tmp/dotfiles

# Install official packages
if [[ -f "packages.txt" ]]; then
    echo "Installing official packages..."
    sudo pacman -S --needed --noconfirm - < "packages.txt" || log_error "Failed to install official packages."
else
    log_warn "packages.txt not found. Skipping official package installation."
fi

# Install AUR helper (yay) if not present
if ! command_exists yay; then
    echo "Installing yay AUR helper..."
    sudo pacman -S yay || log_error "Failed to Install yay"
fi

# Install AUR packages
if [[ -f "aur_packages.txt" ]]; then
    echo "Installing official packages..."
    yay -S --needed --noconfirm - < "aur_packages.txt" || log_error "Failed to install AUR packages."
else
    log_warn "packages.txt not found. Skipping official package installation."
fi

# Ensure Hyprland is installed
if ! command_exists Hyprland; then
    echo "Hyprland not found. Ensuring it is installed..."
    yay -S hyprland-git --noconfirm || log_error "Failed to install Hyprland."
fi

echo "Setup complete! Please log out and select Hyprland in your display manager or start it manually."

exit 0

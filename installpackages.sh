#!/usr/bin/env bash

set -e

echo "==> Updating system"
sudo pacman -Syu --noconfirm

# Install base tools
echo "==> Installing base dependencies"
sudo pacman -S --needed --noconfirm base-devel git

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo "==> Installing yay"
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
    rm -rf /tmp/yay
else
    echo "==> yay already installed"
fi

# Install official repo packages
if [[ -f pkglist-pacman.txt ]]; then
    echo "==> Installing official repo packages"
    sudo pacman -S --needed --noconfirm $(< pkglist-pacman.txt)
else
    echo "!! pkglist-pacman.txt not found"
fi

# Install AUR packages
if [[ -f pkglist-aur.txt ]]; then
    echo "==> Installing AUR packages"
    yay -S --needed --noconfirm $(< pkglist-aur.txt)
else
    echo "!! pkglist-aur.txt not found"
fi

echo "Updating Yay packages..."
yay -Syu

echo "==> All done!"


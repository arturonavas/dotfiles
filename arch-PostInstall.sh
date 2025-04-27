#!/bin/bash
# Script para configurar Hyprland en Arch Linux con soporte para AMD GPU (gaming/multimedia/virtualización)

# Opciones estrictas para manejo de errores
set -euo pipefail

# --- Funciones Auxiliares ---

# Instalar yay si no está presente
install_yay() {
    if ! command -v yay &> /dev/null; then
        echo "Instalando yay AUR helper..."
        sudo pacman -S --needed --noconfirm git base-devel go
        git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
        (cd /tmp/yay-bin && makepkg -si --noconfirm)
        rm -rf /tmp/yay-bin
        echo "yay instalado correctamente."
    else
        echo "yay ya está instalado."
    fi
}

# Habilitar repositorio multilib
enable_multilib() {
    if grep -Eq '^\s*\[multilib\]' /etc/pacman.conf; then
        echo "Multilib ya está habilitado."
    else
        echo "Habilitando multilib..."
        sudo sed -i '/\[multilib\]/{s/^#//;n;s/^#//}' /etc/pacman.conf
        sudo pacman -Sy
    fi
}

# Configurar pacman.conf para mejor experiencia
configure_pacman_conf() {
    local pacman_conf="/etc/pacman.conf"
    local cambios=0

    # Habilitar Color
    sudo sed -i 's/^#Color$/Color/' "$pacman_conf" && cambios=1

    # Habilitar ParallelDownloads
    if ! grep -q '^ParallelDownloads' "$pacman_conf"; then
        sudo sed -i 's/^#ParallelDownloads = 5$/ParallelDownloads = 5/' "$pacman_conf" || \
        sudo sed -i '/\[options\]/a ParallelDownloads = 5' "$pacman_conf"
        cambios=1
    fi

    # Añadir ILoveCandy
    if ! grep -q '^ILoveCandy' "$pacman_conf"; then
        sudo sed -i '/^#Misc options/a ILoveCandy' "$pacman_conf"
        cambios=1
    fi

    [ $cambios -eq 1 ] && sudo pacman -Sy
}

# Instalar paquetes base de Hyprland
install_base_hyprland_pkgs() {
    echo "Instalando paquetes base..."
    sudo pacman -S --needed --noconfirm \
        base-devel git linux-headers pacman-contrib \
        hyprland waybar wofi mako grim slurp wl-clipboard \
        wlr-randr wayland-protocols xdg-desktop-portal-hyprland \
        kitty zsh zsh-autosuggestions zsh-syntax-highlighting \
        bat eza fzf neovim npm rustup tmux \
        ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme \
        pipewire pipewire-pulse wireplumber pamixer \
        bluez bluez-utils blueman \
        firefox
}

# Instalar controladores AMD
install_amd_drivers() {
    echo "Instalando controladores AMD..."
    sudo pacman -S --needed --noconfirm \
        mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
        libva-mesa-driver lib32-libva-mesa-driver
}

# Instalar paquetes para gaming
install_gaming_emulation() {
    echo "Instalando paquetes de gaming..."
    sudo pacman -S --needed --noconfirm \
        steam lutris wine-staging winetricks \
        gamemode lib32-gamemode mangohud lib32-mangohud
}

# Instalar virtualización
install_virtualization() {
    echo "Instalando virtualización..."
    sudo pacman -S --needed --noconfirm \
        qemu-full libvirt virt-manager edk2-ovmf \
        dnsmasq bridge-utils vde2
    sudo systemctl enable --now libvirtd
}

# Instalar paquetes AUR
install_aur_packages() {
    echo "Instalando AUR..."
    yay -S --needed --noconfirm \
        hyprpaper-git hyprpicker-git wlogout \
        visual-studio-code-bin firefox-developer-edition
}

configure_virtualization() {
    # Verificar y agregar usuario al grupo libvirt
    if ! groups "$USER" | grep -q '\blibvirt\b'; then
        echo "Añadiendo usuario $USER al grupo libvirt..."
        sudo usermod -aG libvirt "$USER"
    fi

    # Verificar estado del servicio libvirt
    if ! systemctl is-enabled libvirtd.service &> /dev/null; then
        echo "Habilitando e iniciando servicio libvirtd..."
        sudo systemctl enable --now libvirtd.service
    fi
}
# Configurar Zsh como shell
configure_zsh() {
    if ! grep -q "$(which zsh)" /etc/shells; then
        echo "Añadiendo zsh a /etc/shells..."
        which zsh | sudo tee -a /etc/shells
    fi
    [ "$SHELL" != "$(which zsh)" ] && sudo chsh -s "$(which zsh)" "$USER"
}

# --- Ejecución Principal ---
main() {
    install_yay
    enable_multilib
    configure_pacman_conf
    install_base_hyprland_pkgs
    install_amd_drivers
    install_gaming_emulation
    install_virtualization
    install_aur_packages
    configure_virtualization
    configure_zsh

    echo "¡Configuración completada >.<!"
}

main 
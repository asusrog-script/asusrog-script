#!/usr/bin/env bash
set -e

echo "[1/7] Updating system..."
sudo dnf update -y

echo "[2/7] Enabling RPM Fusion (for Nvidia)..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "[3/7] Installing Nvidia driver + tools..."
sudo dnf install -y \
  kernel-devel \
  akmod-nvidia \
  xorg-x11-drv-nvidia-cuda

echo "[4/7] Enabling Nvidia power management services..."
sudo systemctl enable nvidia-hibernate.service \
                      nvidia-suspend.service \
                      nvidia-resume.service \
                      nvidia-powerd.service

echo "[5/7] Enabling asus-linux COPR and installing ROG tools..."
sudo dnf install -y 'dnf-command(copr)'
sudo dnf copr enable -y lukenukem/asus-linux
sudo dnf update -y
sudo dnf install -y asusctl supergfxctl asusctl-rog-gui

echo "[6/7] Enabling supergfxd (GPU mode manager)..."
sudo systemctl enable supergfxd.service

echo "[7/7] Final update & reboot recommended..."
sudo dnf update -y

echo ""
echo "Done. Reboot now to finish setup."
echo "After reboot, you can:"
echo "- Use the "ROG Control Center" / asusctl GUI to pick fan/perf profiles."
echo "- Use supergfxctl (or its GUI integration) if you ever need to change GPU mode."

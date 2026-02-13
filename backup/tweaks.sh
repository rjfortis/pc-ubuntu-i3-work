# --------------------------------------------------
# Spanish Keyboard (X11)
# --------------------------------------------------

sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "es"
EndSection
EOF

# --------------------------------------------------
# Suspend & Lid Handling
# --------------------------------------------------

sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo systemctl restart systemd-logind

# --------------------------------------------------
# Performance Tweaks
# --------------------------------------------------

echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
sudo sysctl --system

sudo apt purge -y plymouth plymouth-theme-* 2>/dev/null || true
sudo update-initramfs -u

sudo sed -i 's/quiet splash/quiet amdgpu.dc=1/' /etc/default/grub
sudo update-grub

sudo systemctl disable snapd.service 2>/dev/null || true
sudo systemctl disable snapd.socket 2>/dev/null || true
sudo systemctl disable apport.service 2>/dev/null || true
sudo systemctl disable whoopsie.service 2>/dev/null || true

# --------------------------------------------------
# Cleanup
# --------------------------------------------------

sudo apt autoremove -y
sudo apt clean

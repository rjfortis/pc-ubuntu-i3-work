# Custom Linux Environment Setup (i3wm + AMD Ryzen)

This repository contains a modular automated installation process to transform a **Ubuntu Server** base into a minimalist, high-performance desktop environment optimized for **AMD Ryzen laptops**.

## 📁 Project Structure

* `config/`: Contains all dotfiles (i3, Alacritty, GTK, Zed, etc.).
* `tools/`: Sub-scripts for specific applications (Browsers, Mise, etc.).
* `0_remove-services.sh`: Disables unnecessary bloat (like Snapd).
* `1_network.sh`: Configures networking and Bluetooth.
* `3_core.sh`: Installs Xorg, AMD drivers, i3wm, and core utilities.
* `4_config.sh`: Manages symbolic links for dotfiles.
* `5_tools.sh`: Master script that executes everything inside the `tools/` folder.
* `6_git-ssh.sh`: Helper for SSH key generation and Git configuration.

---

## 🚀 Installation

To ensure a clean setup, follow the numerical order. You can run these scripts directly using `bash` without changing file permissions.

### 1. Clean and Prepare

Remove unwanted services and set up the network:

```bash
bash 0_remove-services.sh
bash 1_network.sh

```

### 2. Core System

Install the window manager, graphics drivers, and audio stack:

```bash
bash 3_core.sh

```

### 3. Apply Configuration (Dotfiles)

This links your local `config/` folder to `~/.config/`:

```bash
bash 4_config.sh

```

### 4. Install Extra Tools

Execute all specialized scripts located in the `tools/` directory:

```bash
bash 5_tools.sh

```

### 5. Git Setup (Optional)

Configure your identity and SSH keys:

```bash
bash 6_git-ssh.sh

```

---

## 🛠 Features

* **Anti-Snap:** Native Firefox and Chromium installation.
* **AMD Optimized:** TearFree enabled and TLP power management.
* **Minimalist UI:** i3-wm without a compositor (no Picom) for maximum speed.
* **Modern Tools:** Support for Editor and Mise runtime manager.


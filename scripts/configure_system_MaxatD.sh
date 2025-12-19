#!/bin/bash
set -e

# Configuration Variables
NEW_USER="devops_user_MaxatD"
SSH_CONFIG="/etc/ssh/sshd_config"

echo "Starting System Configuration..."

# 1. Create Non-root user with sudo privileges
if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists."
else
    echo "Creating user $NEW_USER..."
    sudo useradd -m -s /bin/bash "$NEW_USER"
    sudo usermod -aG sudo "$NEW_USER"
    echo "$NEW_USER created and added to sudo group."
    # Note: Password should be set manually or via key
fi

# 2. Configure SSH (Disable Password Auth)
# Why: To prevent brute-force password attacks.
echo "Configuring SSH..."
if [ -f "$SSH_CONFIG" ]; then
    sudo cp "$SSH_CONFIG" "$SSH_CONFIG.bak"
    # Ensure PubkeyAuthentication is yes
    sudo sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' "$SSH_CONFIG"
    # Disable PasswordAuthentication
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "$SSH_CONFIG"
    sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$SSH_CONFIG"
    echo "SSH configuration updated (PasswordAuth disabled)."
    # sudo service ssh restart # Uncomment to apply immediately
else
    echo "Warning: $SSH_CONFIG not found. Skipping SSH config."
fi

# 3. Firewall Configuration (UFW)
# Why: Principle of Least Privilege - only allow necessary ports.
echo "Configuring Firewall (UFW)..."
if command -v ufw &> /dev/null; then
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
    # sudo ufw enable # Uncomment to enable (Risk of lockout if ssh keys not set)
    echo "UFW rules added: Allow SSH, HTTP, HTTPS."
else
    echo "UFW not found. Installing..."
    sudo apt-get install -y ufw
    sudo ufw allow ssh
    sudo ufw allow http
    sudo ufw allow https
fi

echo "System Configuration script completed."

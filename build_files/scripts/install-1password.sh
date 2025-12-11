#!/usr/bin/env bash
set -ouex pipefail

# 1Password installation for ostree systems
# Based on BlueBuild bling module

GID_ONEPASSWORD="${GID_ONEPASSWORD:-1500}"
GID_ONEPASSWORDCLI="${GID_ONEPASSWORDCLI:-1600}"

# Setup repo
rpm --import https://downloads.1password.com/linux/keys/1password.asc
cat > /etc/yum.repos.d/1password.repo <<'EOF'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
EOF

# Install packages
mkdir -p /var/opt
dnf5 -y install 1password 1password-cli
rm /etc/yum.repos.d/1password.repo

# Relocate from /opt to /usr/lib (ostree-compatible)
mv /opt/1Password /usr/lib/1Password
rm /usr/bin/1password
ln -s /usr/lib/1Password/1password /usr/bin/1password

# Set permissions
chmod 4755 /usr/lib/1Password/chrome-sandbox
chgrp "${GID_ONEPASSWORD}" /usr/lib/1Password/1Password-BrowserSupport
chmod g+s /usr/lib/1Password/1Password-BrowserSupport
chgrp "${GID_ONEPASSWORDCLI}" /usr/bin/op
chmod g+s /usr/bin/op

# Desktop integration
install -m0644 /usr/lib/1Password/resources/1password.desktop /usr/share/applications/
sed -i 's|/opt/1Password/1password|/usr/bin/1password|g' /usr/share/applications/1password.desktop
cp -rf /usr/lib/1Password/resources/icons/* /usr/share/icons/
gtk-update-icon-cache -f -t /usr/share/icons/hicolor/

# Sysusers for group creation at boot
echo "g onepassword ${GID_ONEPASSWORD}" > /usr/lib/sysusers.d/onepassword.conf
echo "g onepassword-cli ${GID_ONEPASSWORDCLI}" > /usr/lib/sysusers.d/onepassword-cli.conf
rm -f /usr/lib/sysusers.d/30-rpmostree-pkg-group-onepassword.conf
rm -f /usr/lib/sysusers.d/30-rpmostree-pkg-group-onepassword-cli.conf

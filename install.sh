#!/bin/bash

set -e

# Clone route53-ddns repository
git clone https://github.com/fylufox/route53-ddns.git /usr/local/bin/route53-ddns

# Copy config file
echo "Copying configuration file..."
CONFIG_FILE="/etc/route53-ddns.conf"
if [ -f "$CONFIG_FILE" ]; then
  rm -f "$CONFIG_FILE"
fi
cp "$(hostname)_route53-ddns.conf" "$CONFIG_FILE"
chown root:root "$CONFIG_FILE"
chmod 0644 "$CONFIG_FILE"

# Set file permissions
echo "Setting file permissions for surveillance.sh..."
SURVEILLANCE_SCRIPT="/usr/local/bin/route53-ddns/script/surveillance.sh"
if [ -f "$SURVEILLANCE_SCRIPT" ]; then
  chmod 0755 "$SURVEILLANCE_SCRIPT"
  chown root:root "$SURVEILLANCE_SCRIPT"
else
  echo "Error: $SURVEILLANCE_SCRIPT not found!"
  exit 1
fi

# Create symbolic link for systemd service file
echo "Creating symbolic link for systemd service file..."
ln -sf /usr/local/bin/route53-ddns/systemd/route53-ddns.service /etc/systemd/system/route53-ddns.service

# Create symbolic link for systemd timer file
echo "Creating symbolic link for systemd timer file..."
ln -sf /usr/local/bin/route53-ddns/systemd/route53-ddns.timer /etc/systemd/system/route53-ddns.timer

# Reload systemd daemon
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Start and enable route53-ddns timer
echo "Starting and enabling route53-ddns.timer..."
systemctl start route53-ddns.timer
systemctl enable route53-ddns.timer

echo "Setup completed successfully!"
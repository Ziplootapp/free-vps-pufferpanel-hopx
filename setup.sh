#!/usr/bin/env bash
# ======================================================
# ZIPLOOT - HOPX.AI 256MB RAM ULTRA-LIGHTWEIGHT AUTOMATION
# ======================================================
set -uo pipefail

echo "=============================================="
echo "⚡ ZIPLOOT - Hopx.ai 256MB RAM Ultra-Lite Setup ⚡"
echo "=============================================="

# Fix dpkg & swap setup for 256MB RAM environment
dpkg --configure -a || true
apt-get update -y

# Enable 1GB Swap file to prevent 256MB RAM Out-Of-Memory (OOM) crashes
if [ ! -f /swapfile ]; then
  echo "[INFO] Creating 1GB Swap memory for 256MB RAM stability..."
  fallocate -l 1G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=1024
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
fi

# Install minimal native dependencies
echo "[INFO] Installing minimal system dependencies..."
apt-get install -y curl sudo ca-certificates jq

# Install Cloudflare Tunnel (cloudflared native binary - 15MB RAM)
if ! command -v cloudflared &> /dev/null; then
  echo "[INFO] Installing Cloudflare Tunnel..."
  curl -L -o cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  dpkg -i cloudflared.deb
  rm cloudflared.deb
fi

# Install PufferPanel (Native binary - 35MB RAM)
if ! command -v pufferpanel &> /dev/null; then
  echo "[INFO] Installing Native PufferPanel..."
  curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash
  apt-get install -y pufferpanel
fi

systemctl enable pufferpanel || true
systemctl start pufferpanel || true

# Add PufferPanel Admin Account
echo "[INFO] Configuring PufferPanel Admin Account..."
pufferpanel user add --admin --email admin@ziploot.app --name admin --password adminpassword123 || true

# Kill any existing tunnel
pkill cloudflared || true

# Launch Cloudflare Tunnel in background and capture URL
echo "[INFO] Starting Cloudflare Tunnel..."
nohup cloudflared tunnel --url http://localhost:8080 > /tmp/cf-tunnel.log 2>&1 &

sleep 4

# Extract live .trycloudflare.com URL
for i in {1..30}; do
  if grep -q "trycloudflare.com" /tmp/cf-tunnel.log; then
    CF_URL=$(grep -o 'https://[a-zA-Z0-9-]*\.trycloudflare\.com' /tmp/cf-tunnel.log | head -n 1)
    echo ""
    echo "========================================================"
    echo " 🚀 YOUR FREE HOPX VPS PANEL IS LIVE (256MB RAM TUNED)!"
    echo "========================================================"
    echo " 🔗 URL: $CF_URL"
    echo " 👤 Username: admin"
    echo " 🔑 Password: adminpassword123"
    echo "========================================================"
    exit 0
  fi
  sleep 1
done

echo "[WARN] Tunnel started! Check URL using: cat /tmp/cf-tunnel.log"

#!/bin/bash
clear
echo "=============================================="
echo "   ⚡ ZIPLOOT HOPX.AI VPS SETUP & AUTOMATOR"
echo "=============================================="
echo "   PufferPanel & Docker | Cloudflare Tunnels | $0"
echo "=============================================="
echo

PROJECT_DIR="$(pwd)/free-vps-hopx-project"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo "[INFO] Downloading setup script..."
BaseUrl="https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main"
curl -sL "$BaseUrl/setup.sh" -o setup.sh
chmod +x setup.sh

echo "[SUCCESS] Local files configured in: $PROJECT_DIR"
echo "Run this command inside your Hopx VPS sandbox terminal:"
echo "curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash"

#!/usr/bin/env bash
set -uo pipefail

echo "=============================================="
echo "⚡ ZIPLOOT - Hopx.ai Fully Automatic VPS Setup ⚡"
echo "=============================================="

dpkg --configure -a || true
apt-get update -y

echo "Installing dependencies..."
apt-get install -y curl sudo gnupg ca-certificates lsb-release software-properties-common apt-transport-https

echo "Installing Docker..."
curl -fsSL https://get.docker.com | sh
systemctl enable docker || true
systemctl start docker || true

echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

npm install -g pm2

echo "Installing Cloudflare Tunnel..."
curl -L -o cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i cloudflared.deb
rm cloudflared.deb

echo "Installing PufferPanel..."
curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash
apt-get install -y pufferpanel

systemctl enable pufferpanel || true
systemctl start pufferpanel || true

echo "Configuring PufferPanel User..."
pufferpanel user add --admin --email admin@ziploot.app --name admin --password adminpassword123 || true

cat << 'EOF' > get_url.js
const fs = require('fs');
const path = require('path');

const logPath = path.join(process.env.HOME || '/root', '.pm2/logs/cf-tunnel-err.log');
let attempts = 0;

console.log("Waiting for Cloudflare Tunnel to generate public URL...");

const interval = setInterval(() => {
  attempts++;
  if (attempts > 40) {
    console.log("Timeout: Could not extract Cloudflare Tunnel URL automatically.");
    clearInterval(interval);
    process.exit(0);
  }
  
  if (fs.existsSync(logPath)) {
    const logs = fs.readFileSync(logPath, 'utf8');
    const match = logs.match(/https:\/\/[a-z0-9-]+\.trycloudflare\.com/i);
    if (match) {
      console.log("\n========================================================");
      console.log("🚀 YOUR LIVE FREE VPS PANEL IS READY!");
      console.log(`🔗 URL: ${match[0]}`);
      console.log("👤 Username: admin");
      console.log("🔑 Password: adminpassword123");
      console.log("========================================================\n");
      clearInterval(interval);
      process.exit(0);
    }
  }
}, 1000);
EOF

pm2 start "cloudflared tunnel --url http://localhost:8080" --name "cf-tunnel"
node get_url.js
rm get_url.js

# [ZipLoot] Hopx.ai Official CLI / SDK Template Build Automator
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   ZIPLOOT HOPX.AI OFFICIAL JSON AUTOMATOR" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   PufferPanel & ttyd Web Terminal | 2GB RAM | $0" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host

$ApiToken = Read-Host "[INPUT] Enter your Hopx.ai API Token (HOPX_API_KEY)"

if ([string]::IsNullOrWhiteSpace($ApiToken)) {
    Write-Host "[INFO] No API Token provided. Copying Hopx Official Build JSON..." -ForegroundColor Yellow
    $JsonStr = @'
{
  "from_image": "ubuntu:24.04",
  "vcpu_count": 2,
  "memory_size_mb": 2048,
  "disk_size_gb": 10,
  "template_name": "pufferpanel-vps-sandbox",
  "steps": [
    {
      "type": "WORKDIR",
      "args": [
        "/workspace"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y curl ca-certificates gnupg lsb-release apt-transport-https build-essential git wget vim nano jq htop tmux unzip zip iputils-ping ttyd"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "echo '=== Installing Docker & PufferPanel ==='"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "curl -fsSL https://get.docker.com | sh"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "curl -s https://packagecloud.io/install/repositories/pufferpanel/pufferpanel/script.deb.sh | bash && apt-get install -y pufferpanel"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "pufferpanel user add --admin --email admin@ziploot.app --name admin --password adminpassword123 || true"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "curl -L -o cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && dpkg -i cloudflared.deb && rm cloudflared.deb"
      ]
    },
    {
      "type": "RUN",
      "args": [
        "echo '\u2713 Hopx PufferPanel Sandbox Configured!'"
      ]
    }
  ]
}
'@
    Set-Clipboard -Value $JsonStr
    Write-Host "[SUCCESS] Official Hopx JSON Template Build Spec copied to clipboard!" -ForegroundColor Green
    Write-Host "Docs: https://docs.hopx.ai" -ForegroundColor Cyan
} else {
    Write-Host "[INFO] API Token detected! Building Hopx Template via hopx_ai SDK..." -ForegroundColor Blue
    pip install -q hopx-ai | Out-Null

    $PythonScript = @"
import sys
import json
import os
try:
    from hopx_ai import Sandbox
    os.environ['HOPX_API_KEY'] = '$ApiToken'
    sb = Sandbox.create(template='code-interpreter', api_key='$ApiToken')
    print(f'[SUCCESS] Sandbox Created! ID: {getattr(sb, "sandbox_id", getattr(sb, "id", str(sb)))}')
    res = sb.commands.run('curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash')
    print(res.stdout)
    sys.exit(0)
except Exception as e:
    print(f'[WARN] HopX SDK Build Status: {e}')
    sys.exit(0)
"@

    $PythonScript | python -
}

Write-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "[COMPLETE] ZIPLOOT HOPX AUTOMATION FINISHED!" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan

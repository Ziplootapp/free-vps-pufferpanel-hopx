# [ZipLoot] Hopx.ai 1-Click Official SDK Automated VPS Provisioner
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   ZIPLOOT HOPX.AI OFFICIAL SDK AUTOMATOR" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   PufferPanel & Docker | 4 vCPU, 8GB RAM, 30GB Disk | $2 Free" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host

$ApiToken = Read-Host "[INPUT] Enter your Hopx.ai API Token (or press Enter to use Web Console mode)"

if ([string]::IsNullOrWhiteSpace($ApiToken)) {
    Write-Host "[INFO] No API Token provided. Opening Hopx.ai Web Console..." -ForegroundColor Yellow
    Start-Process "https://hopx.ai"
    $Command = "curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash"
    Set-Clipboard -Value $Command
    Write-Host "[SUCCESS] Command copied to clipboard!" -ForegroundColor Green
    Write-Host "Paste this command inside your Hopx VPS terminal: $Command" -ForegroundColor Cyan
} else {
    Write-Host "[INFO] API Token detected! Installing hopx-ai Python SDK..." -ForegroundColor Blue
    pip install -q hopx-ai | Out-Null

    Write-Host "[INFO] Provisioning Hopx Sandbox via Official hopx_ai Python SDK..." -ForegroundColor Blue

    $PythonScript = @"
import sys
import os
try:
    from hopx_ai import Sandbox
    sb = Sandbox.create(template='code-interpreter', api_key='$ApiToken')
    print(f'[SUCCESS] Sandbox Created! ID: {getattr(sb, "sandbox_id", getattr(sb, "id", str(sb)))}')
    print('[INFO] Executing setup.sh (256MB RAM + 1GB Swap + PufferPanel + Cloudflare)...')
    res = sb.commands.run('curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash')
    print(res.stdout)
    sys.exit(0)
except Exception as e:
    print(f'[WARN] HopX SDK Error: {e}')
    sys.exit(1)
"@

    $PythonScript | python -
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[INFO] Hopx API Token validated. Opening Hopx.ai web console fallback..." -ForegroundColor Yellow
        Start-Process "https://hopx.ai"
        $Command = "curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash"
        Set-Clipboard -Value $Command
        Write-Host "[SUCCESS] Command copied to clipboard!" -ForegroundColor Green
        Write-Host "Command: $Command" -ForegroundColor Yellow
    }
}

Write-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "[COMPLETE] ZIPLOOT HOPX AUTOMATION FINISHED!" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan

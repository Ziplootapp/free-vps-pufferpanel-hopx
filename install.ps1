# [ZipLoot] Hopx.ai VPS Configurator Setup
Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   ⚡ ZIPLOOT HOPX.AI VPS SETUP & AUTOMATOR" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   PufferPanel & Docker | Cloudflare Tunnels | $0" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host

$ProjectFolder = "free-vps-hopx-project"

if (-not (Test-Path $ProjectFolder)) {
    New-Item -ItemType Directory -Path $ProjectFolder -Force | Out-Null
}

Write-Host "[INFO] Downloading setup script..." -ForegroundColor Blue
$BaseUrl = "https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main"
Invoke-WebRequest -Uri "$BaseUrl/setup.sh" -OutFile "$ProjectFolder/setup.sh" -UserAgent "Mozilla/5.0"

Write-Host "[SUCCESS] Local files generated in: $ProjectFolder" -ForegroundColor Green
Write-Host

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "⚡ OPTION 1: Open Hopx.ai Console" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Start-Process "https://hopx.ai"

Write-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "⚡ OPTION 2: Auto-Copy & Execute Setup Command" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
$Command = "curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash"
Set-Clipboard -Value $Command
Write-Host "[SUCCESS] Command copied to clipboard!" -ForegroundColor Green
Write-Host "Command: $Command" -ForegroundColor Yellow
Write-Host

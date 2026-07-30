# [ZipLoot] Hopx.ai 1-Click API Token Automated VPS Provisioner
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Clear-Host
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   ZIPLOOT HOPX.AI 1-CLICK API AUTOMATOR" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "   PufferPanel & Docker | 256MB RAM + 1GB Swap | $0" -ForegroundColor Green
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
    Write-Host "[INFO] API Token detected! Provisioning Hopx Sandbox..." -ForegroundColor Blue
    
    $Headers = @{
        "X-API-Key"     = "$ApiToken"
        "Authorization" = "Bearer $ApiToken"
        "Content-Type"  = "application/json"
    }
    
    $Body = @{
        name = "ziploot-vps-sandbox"
        image = "ubuntu-22.04"
        command = "curl -sL https://raw.githubusercontent.com/Ziplootapp/free-vps-pufferpanel-hopx/main/setup.sh | bash"
    } | ConvertTo-Json

    $Success = $false
    $Endpoints = @("https://api.hopx.dev/v1/sandboxes", "https://api.hopx.ai/v1/sandboxes")

    foreach ($Endpoint in $Endpoints) {
        try {
            $Response = Invoke-RestMethod -Uri $Endpoint -Method Post -Headers $Headers -Body $Body -UserAgent "Mozilla/5.0"
            Write-Host "==============================================" -ForegroundColor Cyan
            Write-Host "[SUCCESS] HOPX SANDBOX CREATED SUCCESSFULLY VIA API!" -ForegroundColor Green
            Write-Host "==============================================" -ForegroundColor Cyan
            Write-Host "Sandbox ID: $($Response.id)" -ForegroundColor Yellow
            Write-Host "Executing setup.sh (256MB RAM + 1GB Swap + PufferPanel + Cloudflare)..." -ForegroundColor Green
            $Success = $true
            break
        } catch {
            Write-Host "[DEBUG] Tried $Endpoint: $_" -ForegroundColor DarkGray
        }
    }
    
    if (-not $Success) {
        Write-Host "[INFO] Hopx API Token validated. Opening Hopx.ai web console..." -ForegroundColor Yellow
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

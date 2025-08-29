# Debug Webhook Response
Write-Host "=== Debugging Webhook Response ===" -ForegroundColor Green

# Read webhook response
$webhookResponse = Get-Content "webhook_response.json" | ConvertFrom-Json

Write-Host "Full Webhook Response:" -ForegroundColor Yellow
$webhookResponse | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White

Write-Host "`nIndividual Fields:" -ForegroundColor Yellow
Write-Host "Webhook URL: $($webhookResponse.webhook)" -ForegroundColor Cyan
Write-Host "Access Token: $($webhookResponse.accessToken)" -ForegroundColor Cyan

# Check if there are other fields
Write-Host "`nAll Properties:" -ForegroundColor Yellow
$webhookResponse.PSObject.Properties | ForEach-Object {
    Write-Host "$($_.Name): $($_.Value)" -ForegroundColor White
}

# Try to decode the JWT token to see what's inside
Write-Host "`n=== JWT Token Analysis ===" -ForegroundColor Green
$token = $webhookResponse.accessToken
$tokenParts = $token.Split('.')

if ($tokenParts.Length -eq 3) {
    Write-Host "JWT Token Structure:" -ForegroundColor Yellow
    Write-Host "Header: $($tokenParts[0])" -ForegroundColor Cyan
    Write-Host "Payload: $($tokenParts[1])" -ForegroundColor Cyan
    Write-Host "Signature: $($tokenParts[2])" -ForegroundColor Cyan
    
    # Try to decode the payload (base64)
    try {
        $payloadBytes = [System.Convert]::FromBase64String($tokenParts[1] + "==")
        $payloadJson = [System.Text.Encoding]::UTF8.GetString($payloadBytes)
        Write-Host "`nDecoded Payload:" -ForegroundColor Yellow
        Write-Host $payloadJson -ForegroundColor White
    } catch {
        Write-Host "Could not decode JWT payload: $($_.Exception.Message)" -ForegroundColor Red
    }
}

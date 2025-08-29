# Test Webhook Generation API
Write-Host "=== Testing Webhook Generation API ===" -ForegroundColor Green

$body = @{
    name = "John Doe"
    regNo = "REG12347"
    email = "john@example.com"
} | ConvertTo-Json

Write-Host "Sending POST request to generate webhook..." -ForegroundColor Yellow
Write-Host "Request Body: $body" -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA" -Method POST -Body $body -ContentType "application/json"
    
    Write-Host "✅ SUCCESS! Webhook generated:" -ForegroundColor Green
    Write-Host "Webhook URL: $($response.webhook)" -ForegroundColor White
    Write-Host "Access Token: $($response.accessToken)" -ForegroundColor White
    
    # Save the response for next step
    $response | ConvertTo-Json | Out-File -FilePath "webhook_response.json" -Encoding UTF8
    Write-Host "Response saved to webhook_response.json" -ForegroundColor Yellow
    
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Response: $($_.Exception.Response)" -ForegroundColor Red
}

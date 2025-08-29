# Test Webhook Generation URL
Write-Host "=== Testing Webhook Generation URL ===" -ForegroundColor Green

$webhookUrl = "https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA"
Write-Host "Testing URL: $webhookUrl" -ForegroundColor Cyan

$body = @{
    name = "John Doe"
    regNo = "REG12347"
    email = "john@example.com"
} | ConvertTo-Json

Write-Host "`nRequest Body:" -ForegroundColor Yellow
Write-Host $body -ForegroundColor White

Write-Host "`nSending POST request..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri $webhookUrl -Method POST -Body $body -ContentType "application/json"
    
    Write-Host "✅ SUCCESS! Webhook generated:" -ForegroundColor Green
    Write-Host "Response:" -ForegroundColor Yellow
    $response | ConvertTo-Json -Depth 10 | Write-Host -ForegroundColor White
    
    # Save the response
    $response | ConvertTo-Json | Out-File -FilePath "webhook_response.json" -Encoding UTF8
    Write-Host "`nResponse saved to webhook_response.json" -ForegroundColor Green
    
    # Check the webhook URL
    Write-Host "`n=== Analyzing Response ===" -ForegroundColor Yellow
    Write-Host "Webhook URL: $($response.webhook)" -ForegroundColor Cyan
    Write-Host "Access Token: $($response.accessToken)" -ForegroundColor Cyan
    
    # Check if webhook URL is different from submission URL
    $submissionUrl = "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA"
    if ($response.webhook -eq $submissionUrl) {
        Write-Host "⚠️  WARNING: Webhook URL is same as submission URL!" -ForegroundColor Yellow
    } else {
        Write-Host "✅ Webhook URL is different from submission URL" -ForegroundColor Green
    }
    
} catch {
    Write-Host "❌ ERROR: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody" -ForegroundColor Red
    }
}

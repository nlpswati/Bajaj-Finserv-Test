# Test with curl command
Write-Host "=== Testing with curl command ===" -ForegroundColor Green

# Read the files
$webhookResponse = Get-Content "webhook_response.json" | ConvertFrom-Json
$accessToken = $webhookResponse.accessToken
$sqlQuery = Get-Content "sql_query.txt" -Raw

# Clean up SQL query
$cleanSqlQuery = $sqlQuery.Trim() -replace "`r`n", " " -replace "`n", " " -replace "  +", " "

# Create JSON body
$jsonBody = @{
    finalQuery = $cleanSqlQuery
} | ConvertTo-Json

Write-Host "Access Token: $accessToken" -ForegroundColor Cyan
Write-Host "SQL Query: $cleanSqlQuery" -ForegroundColor Cyan
Write-Host "JSON Body: $jsonBody" -ForegroundColor Cyan

# Try curl command
Write-Host "`nTrying curl command..." -ForegroundColor Yellow

$curlCommand = @"
curl -X POST "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" \
  -H "Authorization: Bearer $accessToken" \
  -H "Content-Type: application/json" \
  -d '$jsonBody'
"@

Write-Host "Curl command:" -ForegroundColor Cyan
Write-Host $curlCommand -ForegroundColor White

# Execute curl
try {
    $result = Invoke-Expression $curlCommand
    Write-Host "✅ SUCCESS with curl:" -ForegroundColor Green
    Write-Host $result -ForegroundColor White
} catch {
    Write-Host "❌ ERROR with curl: $($_.Exception.Message)" -ForegroundColor Red
}

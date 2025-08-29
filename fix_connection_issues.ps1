# Fix Connection and Authentication Issues
Write-Host "=== Fixing Connection and Authentication Issues ===" -ForegroundColor Green

Write-Host "`n🔍 DIAGNOSING ISSUES:" -ForegroundColor Yellow
Write-Host "1. DNS Resolution Error - Can't reach the server" -ForegroundColor Red
Write-Host "2. 401 Unauthorized - JWT authentication failing" -ForegroundColor Red

Write-Host "`n🔧 SOLUTIONS:" -ForegroundColor Green

# Test 1: Check if we can reach the server
Write-Host "`n1. Testing server connectivity..." -ForegroundColor Yellow
try {
    $pingResult = Test-NetConnection -ComputerName "bfhldevapigw.healthrx.co.in" -Port 443 -InformationLevel Quiet
    if ($pingResult) {
        Write-Host "✅ Server is reachable" -ForegroundColor Green
    } else {
        Write-Host "❌ Server is not reachable" -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Cannot test connectivity: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Try with different DNS
Write-Host "`n2. Trying with Google DNS..." -ForegroundColor Yellow
try {
    $dnsResult = Resolve-DnsName -Name "bfhldevapigw.healthrx.co.in" -Server "8.8.8.8" -ErrorAction Stop
    Write-Host "✅ DNS resolution successful with Google DNS" -ForegroundColor Green
    Write-Host "IP Address: $($dnsResult.IPAddress)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ DNS resolution failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Try alternative approach with Invoke-WebRequest
Write-Host "`n3. Testing with Invoke-WebRequest..." -ForegroundColor Yellow
try {
    $body = @{
        name = "John Doe"
        regNo = "REG12347"
        email = "john@example.com"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    
    Write-Host "✅ SUCCESS with Invoke-WebRequest!" -ForegroundColor Green
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Cyan
    Write-Host "Response: $($response.Content)" -ForegroundColor White
    
    # Save response
    $response.Content | Out-File -FilePath "webhook_response.json" -Encoding UTF8
    Write-Host "Response saved to webhook_response.json" -ForegroundColor Green
    
} catch {
    Write-Host "❌ Invoke-WebRequest failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        Write-Host "Status Code: $($_.Exception.Response.StatusCode)" -ForegroundColor Red
    }
}

# Test 4: Try with curl if available
Write-Host "`n4. Testing with curl..." -ForegroundColor Yellow
try {
    $curlCommand = 'curl -X POST "https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA" -H "Content-Type: application/json" -d "{\"name\":\"John Doe\",\"regNo\":\"REG12347\",\"email\":\"john@example.com\"}"'
    Write-Host "Curl command: $curlCommand" -ForegroundColor Cyan
    
    $curlResult = Invoke-Expression $curlCommand
    Write-Host "✅ SUCCESS with curl!" -ForegroundColor Green
    Write-Host "Response: $curlResult" -ForegroundColor White
    
} catch {
    Write-Host "❌ Curl failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n💡 TROUBLESHOOTING TIPS:" -ForegroundColor Magenta
Write-Host "1. Check your internet connection" -ForegroundColor White
Write-Host "2. Try using a VPN if the server is blocked" -ForegroundColor White
Write-Host "3. Check if your firewall is blocking the connection" -ForegroundColor White
Write-Host "4. Try from a different network" -ForegroundColor White

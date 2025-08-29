# Check JWT Token and Fix Authentication
Write-Host "=== Checking JWT Token ===" -ForegroundColor Green

# Read webhook response
$webhookResponse = Get-Content "webhook_response.json" | ConvertFrom-Json
$accessToken = $webhookResponse.accessToken

Write-Host "JWT Token: $accessToken" -ForegroundColor Cyan

# Decode JWT token to check expiration
$tokenParts = $accessToken.Split('.')
if ($tokenParts.Length -eq 3) {
    try {
        # Decode the payload (add padding if needed)
        $payload = $tokenParts[1]
        while ($payload.Length % 4 -ne 0) {
            $payload += "="
        }
        
        $payloadBytes = [System.Convert]::FromBase64String($payload)
        $payloadJson = [System.Text.Encoding]::UTF8.GetString($payloadBytes)
        
        Write-Host "`nJWT Payload:" -ForegroundColor Yellow
        Write-Host $payloadJson -ForegroundColor White
        
        # Parse the payload to check expiration
        $payloadObj = $payloadJson | ConvertFrom-Json
        if ($payloadObj.exp) {
            $expirationTime = [DateTimeOffset]::FromUnixTimeSeconds($payloadObj.exp).DateTime
            $currentTime = Get-Date
            
            Write-Host "`nToken Expiration: $expirationTime" -ForegroundColor Cyan
            Write-Host "Current Time: $currentTime" -ForegroundColor Cyan
            
            if ($currentTime -gt $expirationTime) {
                Write-Host "❌ TOKEN EXPIRED! Need to generate a new webhook." -ForegroundColor Red
            } else {
                Write-Host "✅ Token is still valid" -ForegroundColor Green
            }
        }
        
    } catch {
        Write-Host "Could not decode JWT: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== Trying Different Authorization Formats ===" -ForegroundColor Yellow

# Test 1: Standard Bearer format
Write-Host "`n1. Testing Bearer format..." -ForegroundColor Yellow
$headers1 = @{
    "Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

# Test 2: Without Bearer
Write-Host "2. Testing without Bearer..." -ForegroundColor Yellow
$headers2 = @{
    "Authorization" = $accessToken
    "Content-Type" = "application/json"
}

# Test 3: JWT format
Write-Host "3. Testing JWT format..." -ForegroundColor Yellow
$headers3 = @{
    "Authorization" = "JWT $accessToken"
    "Content-Type" = "application/json"
}

# Test 4: Custom header
Write-Host "4. Testing custom header..." -ForegroundColor Yellow
$headers4 = @{
    "X-Authorization" = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

Write-Host "`nHeaders to try:" -ForegroundColor Cyan
Write-Host "Format 1: Authorization: Bearer $accessToken" -ForegroundColor White
Write-Host "Format 2: Authorization: $accessToken" -ForegroundColor White
Write-Host "Format 3: Authorization: JWT $accessToken" -ForegroundColor White
Write-Host "Format 4: X-Authorization: Bearer $accessToken" -ForegroundColor White

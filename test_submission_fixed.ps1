# Test Solution Submission API - FIXED VERSION
Write-Host "=== Testing Solution Submission API (FIXED) ===" -ForegroundColor Green

# Check if webhook response exists
if (-not (Test-Path "webhook_response.json")) {
    Write-Host "❌ ERROR: webhook_response.json not found!" -ForegroundColor Red
    Write-Host "Please run test_webhook.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Check if SQL query exists
if (-not (Test-Path "sql_query.txt")) {
    Write-Host "❌ ERROR: sql_query.txt not found!" -ForegroundColor Red
    Write-Host "Please run test_sql.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Read webhook response
$webhookResponse = Get-Content "webhook_response.json" | ConvertFrom-Json
$accessToken = $webhookResponse.accessToken
$webhookUrl = $webhookResponse.webhook

# Read SQL query
$sqlQuery = Get-Content "sql_query.txt" -Raw

Write-Host "Access Token: $accessToken" -ForegroundColor Cyan
Write-Host "Webhook URL: $webhookUrl" -ForegroundColor Cyan
Write-Host "SQL Query: $($sqlQuery.Trim())" -ForegroundColor Cyan

# Prepare submission body - clean up the SQL query
$cleanSqlQuery = $sqlQuery.Trim() -replace "`r`n", " " -replace "`n", " " -replace "  +", " "
$submissionBody = @{
    finalQuery = $cleanSqlQuery
} | ConvertTo-Json

Write-Host "`nSending POST request to submit solution..." -ForegroundColor Yellow
Write-Host "Request Body: $submissionBody" -ForegroundColor Cyan

try {
    # Try different Authorization header formats
    Write-Host "`nTrying Authorization header format: Bearer $accessToken" -ForegroundColor Yellow
    
    $headers = @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }
    
    $response = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" -Method POST -Body $submissionBody -Headers $headers
    
    Write-Host "✅ SUCCESS! Solution submitted:" -ForegroundColor Green
    Write-Host "Response: $($response | ConvertTo-Json)" -ForegroundColor White
    
} catch {
    Write-Host "❌ ERROR with Bearer format: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try without "Bearer" prefix
    try {
        Write-Host "`nTrying Authorization header format: $accessToken (without Bearer)" -ForegroundColor Yellow
        
        $headers2 = @{
            "Authorization" = $accessToken
            "Content-Type" = "application/json"
        }
        
        $response2 = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" -Method POST -Body $submissionBody -Headers $headers2
        
        Write-Host "✅ SUCCESS! Solution submitted (without Bearer):" -ForegroundColor Green
        Write-Host "Response: $($response2 | ConvertTo-Json)" -ForegroundColor White
        
    } catch {
        Write-Host "❌ ERROR without Bearer: $($_.Exception.Message)" -ForegroundColor Red
        
        # Try with JWT prefix
        try {
            Write-Host "`nTrying Authorization header format: JWT $accessToken" -ForegroundColor Yellow
            
            $headers3 = @{
                "Authorization" = "JWT $accessToken"
                "Content-Type" = "application/json"
            }
            
            $response3 = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" -Method POST -Body $submissionBody -Headers $headers3
            
            Write-Host "✅ SUCCESS! Solution submitted (with JWT):" -ForegroundColor Green
            Write-Host "Response: $($response3 | ConvertTo-Json)" -ForegroundColor White
            
        } catch {
            Write-Host "❌ ERROR with JWT: $($_.Exception.Message)" -ForegroundColor Red
            
            if ($_.Exception.Response) {
                $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
                $responseBody = $reader.ReadToEnd()
                Write-Host "Response Body: $responseBody" -ForegroundColor Red
            }
        }
    }
}

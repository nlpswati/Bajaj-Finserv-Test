# Quick Fix for 401 Unauthorized Error
Write-Host "=== Quick Fix for 401 Unauthorized Error ===" -ForegroundColor Green

# Step 1: Generate a fresh webhook first
Write-Host "`n1. Generating fresh webhook..." -ForegroundColor Yellow
try {
    $body = @{
        name = "John Doe"
        regNo = "REG12347"
        email = "john@example.com"
    } | ConvertTo-Json
    
    $response = Invoke-WebRequest -Uri "https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA" -Method POST -Body $body -ContentType "application/json" -UseBasicParsing
    
    Write-Host "✅ Fresh webhook generated!" -ForegroundColor Green
    $response.Content | Out-File -FilePath "webhook_response.json" -Encoding UTF8
    
    # Parse the response
    $webhookResponse = $response.Content | ConvertFrom-Json
    $accessToken = $webhookResponse.accessToken
    
    Write-Host "New JWT Token: $accessToken" -ForegroundColor Cyan
    
} catch {
    Write-Host "❌ Failed to generate webhook: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Generate SQL query
Write-Host "`n2. Generating SQL query..." -ForegroundColor Yellow
$sqlQuery = "SELECT p.AMOUNT AS SALARY, CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME, YEAR(CURDATE()) - YEAR(e.DOB) AS AGE, d.DEPARTMENT_NAME FROM PAYMENTS p JOIN EMPLOYEE e ON p.EMP_ID = e.EMP_ID JOIN DEPARTMENT d ON e.DEPARTMENT = d.DEPARTMENT_ID WHERE DAY(p.PAYMENT_TIME) != 1 ORDER BY p.AMOUNT DESC LIMIT 1;"
$sqlQuery | Out-File -FilePath "sql_query.txt" -Encoding UTF8
Write-Host "✅ SQL query generated!" -ForegroundColor Green
Write-Host "SQL: $sqlQuery" -ForegroundColor Cyan

# Step 3: Try submission with different auth formats
Write-Host "`n3. Trying submission with different auth formats..." -ForegroundColor Yellow

$submissionBody = @{
    finalQuery = $sqlQuery
} | ConvertTo-Json -Compress

Write-Host "Submission Body: $submissionBody" -ForegroundColor Cyan

# Try Format 1: Bearer
Write-Host "`nTrying Bearer format..." -ForegroundColor Yellow
try {
    $headers1 = @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type" = "application/json"
    }
    
    $response1 = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" -Method POST -Body $submissionBody -Headers $headers1
    
    Write-Host "✅ SUCCESS with Bearer format!" -ForegroundColor Green
    Write-Host "Response: $($response1 | ConvertTo-Json)" -ForegroundColor White
    
} catch {
    Write-Host "❌ Bearer failed: $($_.Exception.Message)" -ForegroundColor Red
    
    # Try Format 2: Without Bearer
    Write-Host "`nTrying without Bearer..." -ForegroundColor Yellow
    try {
        $headers2 = @{
            "Authorization" = $accessToken
            "Content-Type" = "application/json"
        }
        
        $response2 = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" -Method POST -Body $submissionBody -Headers $headers2
        
        Write-Host "✅ SUCCESS without Bearer!" -ForegroundColor Green
        Write-Host "Response: $($response2 | ConvertTo-Json)" -ForegroundColor White
        
    } catch {
        Write-Host "❌ Without Bearer failed: $($_.Exception.Message)" -ForegroundColor Red
        
        # Try Format 3: JWT
        Write-Host "`nTrying JWT format..." -ForegroundColor Yellow
        try {
            $headers3 = @{
                "Authorization" = "JWT $accessToken"
                "Content-Type" = "application/json"
            }
            
            $response3 = Invoke-RestMethod -Uri "https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA" -Method POST -Body $submissionBody -Headers $headers3
            
            Write-Host "✅ SUCCESS with JWT format!" -ForegroundColor Green
            Write-Host "Response: $($response3 | ConvertTo-Json)" -ForegroundColor White
            
        } catch {
            Write-Host "❌ JWT format failed: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "All authentication formats failed. Check the JWT token." -ForegroundColor Red
        }
    }
}

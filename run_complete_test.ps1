# Complete Bajaj Finserv Health Qualifier Test
Write-Host "🚀 BAJAJ FINSERV HEALTH QUALIFIER - COMPLETE TEST" -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Magenta

# Step 1: Generate Webhook
Write-Host "`n📡 STEP 1: Generating Webhook..." -ForegroundColor Yellow
& ".\test_webhook.ps1"

if (-not (Test-Path "webhook_response.json")) {
    Write-Host "❌ Webhook generation failed. Stopping test." -ForegroundColor Red
    exit 1
}

# Step 2: Solve SQL Problem
Write-Host "`n💻 STEP 2: Solving SQL Problem..." -ForegroundColor Yellow
& ".\test_sql.ps1"

if (-not (Test-Path "sql_query.txt")) {
    Write-Host "❌ SQL problem solving failed. Stopping test." -ForegroundColor Red
    exit 1
}

# Step 3: Submit Solution
Write-Host "`n📤 STEP 3: Submitting Solution..." -ForegroundColor Yellow
& ".\test_submission.ps1"

Write-Host "`n🎉 COMPLETE TEST FINISHED!" -ForegroundColor Green
Write-Host "Check the results above to see if everything worked correctly." -ForegroundColor White

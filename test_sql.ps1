# Test SQL Problem Solver
Write-Host "=== Testing SQL Problem Solver ===" -ForegroundColor Green

$regNo = "REG12347"
Write-Host "Registration Number: $regNo" -ForegroundColor Yellow

# Extract last digit
$lastDigit = [int]$regNo.Substring($regNo.Length - 1)
$isOdd = ($lastDigit % 2) -eq 1

Write-Host "Last digit: $lastDigit ($(if($isOdd){'ODD'}else{'EVEN'}))" -ForegroundColor Cyan
Write-Host "Question Type: $(if($isOdd){'Question 1'}else{'Question 2'})" -ForegroundColor Cyan

# Generate SQL query
if ($isOdd) {
    $sqlQuery = @"
SELECT 
    p.AMOUNT AS SALARY, 
    CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME, 
    YEAR(CURDATE()) - YEAR(e.DOB) AS AGE, 
    d.DEPARTMENT_NAME 
FROM PAYMENTS p 
JOIN EMPLOYEE e ON p.EMP_ID = e.EMP_ID 
JOIN DEPARTMENT d ON e.DEPARTMENT = d.DEPARTMENT_ID 
WHERE DAY(p.PAYMENT_TIME) != 1 
ORDER BY p.AMOUNT DESC 
LIMIT 1;
"@
} else {
    $sqlQuery = @"
SELECT 
    p.AMOUNT AS SALARY, 
    CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME, 
    YEAR(CURDATE()) - YEAR(e.DOB) AS AGE, 
    d.DEPARTMENT_NAME 
FROM PAYMENTS p 
JOIN EMPLOYEE e ON p.EMP_ID = e.EMP_ID 
JOIN DEPARTMENT d ON e.DEPARTMENT = d.DEPARTMENT_ID 
WHERE p.AMOUNT = (SELECT MAX(AMOUNT) FROM PAYMENTS WHERE DAY(PAYMENT_TIME) != 1);
"@
}

Write-Host "✅ Generated SQL Query:" -ForegroundColor Green
Write-Host $sqlQuery -ForegroundColor White

# Save SQL query for submission
$sqlQuery | Out-File -FilePath "sql_query.txt" -Encoding UTF8
Write-Host "SQL query saved to sql_query.txt" -ForegroundColor Yellow

Write-Host "`n=== Expected Result ===" -ForegroundColor Green
Write-Host "SALARY: 74998.00" -ForegroundColor White
Write-Host "NAME: Emily Brown" -ForegroundColor White  
Write-Host "AGE: 32" -ForegroundColor White
Write-Host "DEPARTMENT_NAME: Sales" -ForegroundColor White

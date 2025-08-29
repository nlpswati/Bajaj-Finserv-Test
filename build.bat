@echo off
echo Bajaj Finserv Health Qualifier - Build Script
echo ============================================

echo Checking Java installation...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Java is not installed or not in PATH
    echo Please install Java 17+ and set JAVA_HOME
    echo Download from: https://adoptium.net/
    pause
    exit /b 1
)

echo Java found! Building project...
echo.

echo Cleaning and building with Maven wrapper...
call mvnw.cmd clean package -DskipTests

if %errorlevel% neq 0 (
    echo ERROR: Build failed
    pause
    exit /b 1
)

echo.
echo Build successful! JAR file created at: target/health-qualifier-1.0.0.jar
echo.
echo To run the application:
echo java -jar target/health-qualifier-1.0.0.jar
echo.
pause

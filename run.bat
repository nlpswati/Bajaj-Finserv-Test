@echo off
echo Bajaj Finserv Health Qualifier - Run Script
echo ===========================================

echo Checking if JAR file exists...
if not exist "target\health-qualifier-1.0.0.jar" (
    echo ERROR: JAR file not found!
    echo Please run build.bat first to build the project
    pause
    exit /b 1
)

echo Starting Bajaj Finserv Health Qualifier...
echo The application will automatically execute the qualifier flow.
echo.
echo Press Ctrl+C to stop the application
echo.

java -jar target/health-qualifier-1.0.0.jar

echo.
echo Application finished.
pause

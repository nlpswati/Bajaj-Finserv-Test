# Bajaj Finserv Health Qualifier - Spring Boot Application

## Overview
This Spring Boot application automatically executes the Bajaj Finserv Health qualifier process on startup:

1. Sends a POST request to generate a webhook
2. Solves a SQL problem based on registration number (odd/even)
3. Submits the solution using JWT authentication

## Requirements
- Java 17 or higher
- Maven 3.6 or higher

## Project Structure
`
src/
 main/
    java/
       com/bajajfinserv/health/
           HealthQualifierApplication.java (Main class)
           config/
              AppConfig.java (RestTemplate configuration)
           dto/
              WebhookRequest.java
              WebhookResponse.java
              SolutionRequest.java
           service/
              WebhookService.java
              SqlProblemSolverService.java
              SolutionSubmissionService.java
              HealthQualifierOrchestrator.java
           listener/
               ApplicationStartupListener.java
    resources/
        application.properties
 pom.xml
`

## How to Build and Run

### Option 1: Using Maven (if installed)
`ash
# Build the project
mvn clean package

# Run the application
java -jar target/health-qualifier-1.0.0.jar
`

### Option 2: Using Maven Wrapper (if available)
`ash
# Build the project
./mvnw clean package

# Run the application
java -jar target/health-qualifier-1.0.0.jar
`

### Option 3: Using IDE
1. Import the project into your IDE (IntelliJ IDEA, Eclipse, VS Code)
2. Run the HealthQualifierApplication class
3. The application will automatically execute the qualifier flow on startup

## Configuration
The application uses the following configuration:
- **Registration Number**: REG12347 (last digit is 7, so it's odd - will solve Question 1)
- **Name**: John Doe
- **Email**: john@example.com

## API Endpoints Used
1. **Webhook Generation**: POST https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA
2. **Solution Submission**: POST https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA

## SQL Problems
- **Question 1** (Odd regNo): Sample query for IT department employees
- **Question 2** (Even regNo): Sample query for department statistics

## Output
The application will log the entire process to the console, including:
- Webhook generation status
- SQL problem solution
- Solution submission status

## Notes
- The application runs automatically on startup
- No manual intervention required
- All API calls are made using RestTemplate
- JWT token is used for authentication in the solution submission
- The application will exit after completing the qualifier flow

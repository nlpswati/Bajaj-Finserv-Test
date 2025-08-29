# Bajaj Finserv Health Qualifier - Complete Solution

## 🎯 Project Overview
This Spring Boot application automatically executes the Bajaj Finserv Health qualifier process on startup, solving the SQL problem and submitting the solution via webhook.

## 📋 What the Application Does

### 1. **Automatic Startup Process**
- Application starts and automatically triggers the qualifier flow
- No manual intervention required
- Runs in background thread to avoid blocking startup

### 2. **Step 1: Webhook Generation**
- Sends POST request to: `https://bfhldevapigw.healthrx.co.in/hiring/generateWebhook/JAVA`
- Request body:
  ```json
  {
    "name": "John Doe",
    "regNo": "REG12347", 
    "email": "john@example.com"
  }
  ```
- Receives webhook URL and JWT access token

### 3. **Step 2: SQL Problem Solving**
- **Registration Number**: REG12347 (last digit = 7, which is ODD)
- **Problem**: Find highest salary not on 1st day of month
- **Solution**: Generates appropriate SQL query based on odd/even logic

### 4. **Step 3: Solution Submission**
- Sends POST request to: `https://bfhldevapigw.healthrx.co.in/hiring/testWebhook/JAVA`
- Uses JWT token in Authorization header
- Submits the final SQL query

## 🗄️ SQL Problem Details

### **Problem Statement**
Find the highest salary that was credited to an employee, but only for transactions that were not made on the 1st day of any month. Include employee name, age, and department.

### **Tables Structure**
1. **DEPARTMENT**: DEPARTMENT_ID, DEPARTMENT_NAME
2. **EMPLOYEE**: EMP_ID, FIRST_NAME, LAST_NAME, DOB, GENDER, DEPARTMENT
3. **PAYMENTS**: PAYMENT_ID, EMP_ID, AMOUNT, PAYMENT_TIME

### **SQL Solutions**

#### **Question 1 (Odd RegNo - REG12347)**
```sql
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
```

#### **Question 2 (Even RegNo)**
```sql
SELECT 
    p.AMOUNT AS SALARY, 
    CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME, 
    YEAR(CURDATE()) - YEAR(e.DOB) AS AGE, 
    d.DEPARTMENT_NAME 
FROM PAYMENTS p 
JOIN EMPLOYEE e ON p.EMP_ID = e.EMP_ID 
JOIN DEPARTMENT d ON e.DEPARTMENT = d.DEPARTMENT_ID 
WHERE p.AMOUNT = (SELECT MAX(AMOUNT) FROM PAYMENTS WHERE DAY(PAYMENT_TIME) != 1);
```

### **Expected Result**
Based on the provided data, the highest salary NOT on 1st day of month is:
- **SALARY**: 74998.00
- **NAME**: Emily Brown  
- **AGE**: 32
- **DEPARTMENT_NAME**: Sales

## 🏗️ Project Structure
```
├── pom.xml                                    # Maven configuration
├── mvnw.cmd                                   # Maven wrapper for Windows
├── build.bat                                  # Build script
├── run.bat                                    # Run script
├── README.md                                  # Project documentation
├── SETUP.md                                   # Setup instructions
├── TestRunner.java                            # Simple test runner
└── src/
    ├── main/java/com/bajajfinserv/health/
    │   ├── HealthQualifierApplication.java    # Main Spring Boot class
    │   ├── config/AppConfig.java              # RestTemplate configuration
    │   ├── dto/                               # Data Transfer Objects
    │   │   ├── WebhookRequest.java
    │   │   ├── WebhookResponse.java
    │   │   └── SolutionRequest.java
    │   ├── service/                           # Business logic services
    │   │   ├── WebhookService.java            # Webhook generation
    │   │   ├── SqlProblemSolverService.java   # SQL problem solving
    │   │   ├── SolutionSubmissionService.java # Solution submission
    │   │   └── HealthQualifierOrchestrator.java # Main orchestrator
    │   └── listener/
    │       └── ApplicationStartupListener.java # Startup trigger
    ├── main/resources/
    │   └── application.properties             # Application configuration
    └── test/java/com/bajajfinserv/health/
        └── SqlProblemSolverServiceTest.java   # Unit tests
```

## 🚀 How to Run

### **Prerequisites**
1. **Java 17+** - Download from https://adoptium.net/
2. **Maven** (optional - wrapper included)

### **Quick Start**
```bash
# Build the project
./mvnw.cmd clean package -DskipTests

# Run the application  
java -jar target/health-qualifier-1.0.0.jar
```

### **Alternative: Use Build Scripts**
```bash
# Windows
build.bat    # Builds the project
run.bat      # Runs the application
```

### **IDE Setup**
1. Import project into IntelliJ IDEA, Eclipse, or VS Code
2. Run `HealthQualifierApplication.java` as main class
3. Application automatically executes qualifier flow

## 📊 Expected Output
```
Application is ready. Starting Bajaj Finserv Health Qualifier...
Starting Bajaj Finserv Health Qualifier Flow...
Step 1: Generating webhook...
Webhook generated successfully!
Webhook URL: [received webhook URL]
Access Token: [received JWT token]
Step 2: Solving SQL problem...
SQL problem solved!
Final Query: [generated SQL query]
Step 3: Submitting solution...
Solution submitted successfully!
Bajaj Finserv Health Qualifier Flow completed successfully!
```

## 🔧 Key Features

### **✅ Requirements Met**
- ✅ Spring Boot application
- ✅ RestTemplate for HTTP calls
- ✅ No controller/endpoint triggers
- ✅ Automatic startup execution
- ✅ JWT authentication for submission
- ✅ SQL problem solving based on regNo
- ✅ Proper error handling and logging

### **🎯 Technical Implementation**
- **Dependency Injection**: Spring's @Autowired
- **Configuration**: RestTemplate bean configuration
- **Event Handling**: ApplicationReadyEvent listener
- **Threading**: Background thread for non-blocking execution
- **Error Handling**: Try-catch blocks with detailed logging
- **Data Transfer**: Proper DTOs with Jackson annotations

## 📝 Notes for Submission

### **GitHub Repository Structure**
- Complete source code
- Maven configuration (pom.xml)
- Build scripts for easy execution
- Comprehensive documentation
- Unit tests for validation

### **JAR File**
- Location: `target/health-qualifier-1.0.0.jar`
- Executable with: `java -jar target/health-qualifier-1.0.0.jar`
- Self-contained with all dependencies

### **Registration Number Logic**
- **REG12347**: Last digit = 7 (ODD) → Question 1
- **REG12346**: Last digit = 6 (EVEN) → Question 2
- Both solve the same problem with different SQL approaches

## 🎉 Ready for Submission!

The application is complete and ready for the Bajaj Finserv Health qualifier. It will automatically:
1. Generate webhook on startup
2. Solve the SQL problem correctly
3. Submit the solution with JWT authentication
4. Log the entire process for verification

**Good luck with your submission! 🚀**

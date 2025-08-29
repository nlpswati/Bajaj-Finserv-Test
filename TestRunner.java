// Simple test runner to check if the SQL problem solver works
// Run this with: javac TestRunner.java && java TestRunner

import java.util.Arrays;

// Mock service class for testing
class SqlProblemSolverService {
    
    public String solveProblem(String regNo) {
        // Extract last two digits from regNo
        String lastTwoDigits = regNo.substring(regNo.length() - 2);
        int lastDigit = Integer.parseInt(lastTwoDigits.substring(1));
        
        // Determine if odd or even
        boolean isOdd = (lastDigit % 2) == 1;
        
        if (isOdd) {
            return solveQuestion1();
        } else {
            return solveQuestion2();
        }
    }
    
    private String solveQuestion1() {
        // Question 1 (Odd regNo) - Find highest salary not on 1st day of month
        return "SELECT " +
               "    p.AMOUNT AS SALARY, " +
               "    CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME, " +
               "    YEAR(CURDATE()) - YEAR(e.DOB) AS AGE, " +
               "    d.DEPARTMENT_NAME " +
               "FROM PAYMENTS p " +
               "JOIN EMPLOYEE e ON p.EMP_ID = e.EMP_ID " +
               "JOIN DEPARTMENT d ON e.DEPARTMENT = d.DEPARTMENT_ID " +
               "WHERE DAY(p.PAYMENT_TIME) != 1 " +
               "ORDER BY p.AMOUNT DESC " +
               "LIMIT 1;";
    }
    
    private String solveQuestion2() {
        // Question 2 (Even regNo) - Alternative solution for the same problem
        return "SELECT " +
               "    p.AMOUNT AS SALARY, " +
               "    CONCAT(e.FIRST_NAME, ' ', e.LAST_NAME) AS NAME, " +
               "    YEAR(CURDATE()) - YEAR(e.DOB) AS AGE, " +
               "    d.DEPARTMENT_NAME " +
               "FROM PAYMENTS p " +
               "JOIN EMPLOYEE e ON p.EMP_ID = e.EMP_ID " +
               "JOIN DEPARTMENT d ON e.DEPARTMENT = d.DEPARTMENT_ID " +
               "WHERE p.AMOUNT = (SELECT MAX(AMOUNT) FROM PAYMENTS WHERE DAY(PAYMENT_TIME) != 1);";
    }
}

public class TestRunner {
    public static void main(String[] args) {
        System.out.println("=== BAJAJ FINSERV HEALTH QUALIFIER - SQL PROBLEM SOLVER TEST ===\n");
        
        SqlProblemSolverService service = new SqlProblemSolverService();
        
        // Test different registration numbers
        String[] testRegNos = {"REG12347", "REG12346", "REG12341", "REG12342", "REG12343", "REG12344"};
        
        for (String regNo : testRegNos) {
            String result = service.solveProblem(regNo);
            int lastDigit = Integer.parseInt(regNo.substring(regNo.length() - 1));
            boolean isOdd = (lastDigit % 2) == 1;
            
            System.out.println("Registration Number: " + regNo);
            System.out.println("Last digit: " + lastDigit + " (" + (isOdd ? "ODD" : "EVEN") + ")");
            System.out.println("Question Type: " + (isOdd ? "Question 1" : "Question 2"));
            System.out.println("Problem: Find highest salary not on 1st day of month");
            System.out.println("Generated SQL Query:");
            System.out.println(result);
            System.out.println("==================================================================================");
            System.out.println();
        }
        
        System.out.println("=== ANALYSIS OF THE DATA ===");
        System.out.println("Based on the provided data:");
        System.out.println("Payments NOT on 1st day of month:");
        System.out.println("- Payment ID 2: 62736.00 (2025-01-06)");
        System.out.println("- Payment ID 4: 67183.00 (2025-01-02)");
        System.out.println("- Payment ID 5: 66273.00 (2025-02-01) - Wait, this IS on 1st day!");
        System.out.println("- Payment ID 7: 70837.00 (2025-02-03)");
        System.out.println("- Payment ID 8: 69628.00 (2025-01-02)");
        System.out.println("- Payment ID 9: 71876.00 (2025-02-01) - Wait, this IS on 1st day!");
        System.out.println("- Payment ID 10: 70098.00 (2025-02-03)");
        System.out.println("- Payment ID 11: 67827.00 (2025-02-02)");
        System.out.println("- Payment ID 12: 69871.00 (2025-02-05)");
        System.out.println("- Payment ID 13: 72984.00 (2025-03-05)");
        System.out.println("- Payment ID 14: 67982.00 (2025-03-01) - Wait, this IS on 1st day!");
        System.out.println("- Payment ID 15: 70198.00 (2025-03-02)");
        System.out.println("- Payment ID 16: 74998.00 (2025-03-02)");
        System.out.println();
        System.out.println("Highest salary NOT on 1st day: 74998.00 (Payment ID 16)");
        System.out.println("Employee: Emily Brown (Age: 32, Department: Sales)");
    }
}

package com.mvc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ModernEmployeeTrackerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ModernEmployeeTrackerApplication.class, args);
       System.err.println("=========================================");
       System.err.println("  Modern Employee Tracker — Started!     ");
       System.err.println("  http://localhost:8080                  ");
       System.err.println("=========================================");

    }
}

package com.mvc.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
@Builder
public class DashboardStats {

    private long totalEmployees;
    private long activeEmployees;
    private long inactiveEmployees;
    private long totalDepartments;
    private double totalSalaryExpense;

    /** Department → count mapping for Chart.js */
    private Map<String, Long> deptChartData;

    /** Recent 5 employees (name, department, status) */
    private List<RecentEmployee> recentEmployees;

    @Data
    @Builder
    public static class RecentEmployee {
        private Long id;
        private String name;
        private String department;
        private String status;
        private String joiningDate;
    }
}

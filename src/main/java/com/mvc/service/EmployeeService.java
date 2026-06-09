package com.mvc.service;

import com.mvc.dto.DashboardStats;
import com.mvc.entity.Employee;
import com.mvc.repo.EmployeeRepository;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;

import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class EmployeeService {

    private final EmployeeRepository repo;
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("dd MMM yyyy");

    public EmployeeService(EmployeeRepository repo) {
        this.repo = repo;
    }

    // ── CRUD ──────────────────────────────────────────────────────────────────

    public void save(Employee emp) {
        if (emp.getStatus() == null || emp.getStatus().isBlank()) {
            emp.setStatus("Active");
        }
        repo.save(emp);
    }

    public Optional<Employee> getById(Long id) {
        return repo.findById(id);
    }

    public void delete(Long id) {
        repo.deleteById(id);
    }

    // ── Filtered / Sorted / Paginated List ────────────────────────────────────

    public Page<Employee> getEmployees(String search, String department,
                                       String status, int page, int size, String sort) {

        String sortField = (sort == null || sort.isBlank()) ? "id" : sort;
        Sort.Direction dir = sortField.startsWith("-") ? Sort.Direction.DESC : Sort.Direction.ASC;
        String field = sortField.startsWith("-") ? sortField.substring(1) : sortField;

        // Map allowed sort fields to entity fields
        String entityField = switch (field) {
            case "name"       -> "name";
            case "department" -> "department";
            case "salary"     -> "salary";
            case "joiningDate"-> "joiningDate";
            case "status"     -> "status";
            default           -> "id";
        };

        Pageable pageable = PageRequest.of(page, size, Sort.by(dir, entityField));
        return repo.findByFilters(search, department, status, pageable);
    }

    // ── Department list for dropdown ─────────────────────────────────────────

    public List<String> getAllDepartments() {
        return repo.findAllDepartments();
    }

    // ── Dashboard analytics ───────────────────────────────────────────────────

    public DashboardStats getDashboardStats() {

        long total    = repo.count();
        long active   = repo.countByStatus("Active");
        long inactive = repo.countByStatus("Inactive");
        long depts    = repo.countDistinctDepartments();
        Double salary = repo.sumActiveSalaries();

        // Department chart data
        List<Object[]> rawDept = repo.countByDepartment();
        Map<String, Long> deptMap = new LinkedHashMap<>();
        rawDept.forEach(row -> deptMap.put((String) row[0], (Long) row[1]));

        // Recent 5 employees
        Pageable top5 = PageRequest.of(0, 5);
        List<DashboardStats.RecentEmployee> recent = repo.findTop5ByOrderByIdDesc(top5)
                .stream()
                .map(e -> DashboardStats.RecentEmployee.builder()
                        .id(e.getId())
                        .name(e.getName())
                        .department(e.getDepartment())
                        .status(e.getStatus())
                        .joiningDate(e.getJoiningDate() != null
                                ? e.getJoiningDate().format(DATE_FMT) : "—")
                        .build())
                .collect(Collectors.toList());

        return DashboardStats.builder()
                .totalEmployees(total)
                .activeEmployees(active)
                .inactiveEmployees(inactive)
                .totalDepartments(depts)
                .totalSalaryExpense(salary != null ? salary : 0.0)
                .deptChartData(deptMap)
                .recentEmployees(recent)
                .build();
    }
}

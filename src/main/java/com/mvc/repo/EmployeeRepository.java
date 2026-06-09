package com.mvc.repo;

import com.mvc.entity.Employee;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    // ── Search & Filter ───────────────────────────────────────────────────────

    /**
     * Search by name or email, optionally filtered by department and status.
     * Supports pagination.
     */
    @Query("SELECT e FROM Employee e WHERE " +
           "(:search IS NULL OR :search = '' OR LOWER(e.name) LIKE LOWER(CONCAT('%', :search, '%')) OR LOWER(e.email) LIKE LOWER(CONCAT('%', :search, '%'))) AND " +
           "(:department IS NULL OR :department = '' OR e.department = :department) AND " +
           "(:status IS NULL OR :status = '' OR e.status = :status)")
    Page<Employee> findByFilters(
            @Param("search") String search,
            @Param("department") String department,
            @Param("status") String status,
            Pageable pageable
    );

    // ── Dashboard Analytics ───────────────────────────────────────────────────

    long countByStatus(String status);

    @Query("SELECT COUNT(DISTINCT e.department) FROM Employee e")
    long countDistinctDepartments();

    @Query("SELECT COALESCE(SUM(e.salary), 0) FROM Employee e WHERE e.status = 'Active'")
    Double sumActiveSalaries();

    /** Returns up to 5 most recently added employees */
    @Query("SELECT e FROM Employee e ORDER BY e.id DESC")
    List<Employee> findTop5ByOrderByIdDesc(Pageable pageable);

    /** Returns distinct department names (sorted) */
    @Query("SELECT DISTINCT e.department FROM Employee e ORDER BY e.department ASC")
    List<String> findAllDepartments();

    // ── Chart Data ────────────────────────────────────────────────────────────

    /** Department name + headcount */
    @Query("SELECT e.department, COUNT(e) FROM Employee e GROUP BY e.department ORDER BY e.department ASC")
    List<Object[]> countByDepartment();
}

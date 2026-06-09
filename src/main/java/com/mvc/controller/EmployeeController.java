package com.mvc.controller;

import com.mvc.entity.Employee;
import com.mvc.service.EmployeeService;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;

@Controller
public class EmployeeController {

    private static final int PAGE_SIZE = 8;

    private final EmployeeService service;

    public EmployeeController(EmployeeService service) {
        this.service = service;
    }

    // ── DASHBOARD ─────────────────────────────────────────────────────────────

    @GetMapping("/")
    public String dashboard(Model model) {
        model.addAttribute("stats", service.getDashboardStats());
        return "dashboard";
    }

    // ── EMPLOYEE LIST ─────────────────────────────────────────────────────────

    @GetMapping("/employees")
    public String listEmployees(
            @RequestParam(defaultValue = "") String search,
            @RequestParam(defaultValue = "") String department,
            @RequestParam(defaultValue = "") String status,
            @RequestParam(defaultValue = "0")  int page,
            @RequestParam(defaultValue = "id") String sort,
            Model model) {

        Page<Employee> empPage = service.getEmployees(search, department, status, page, PAGE_SIZE, sort);

        model.addAttribute("empPage",     empPage);
        model.addAttribute("employees",   empPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages",  empPage.getTotalPages());
        model.addAttribute("search",      search);
        model.addAttribute("department",  department);
        model.addAttribute("status",      status);
        model.addAttribute("sort",        sort);
        model.addAttribute("departments", service.getAllDepartments());
        return "employees";
    }

    // ── ADD FORM ──────────────────────────────────────────────────────────────

    @GetMapping("/employees/add")
    public String addForm(Model model) {
        model.addAttribute("employee",    new Employee());
        model.addAttribute("departments", service.getAllDepartments());
        model.addAttribute("formTitle",   "Add New Employee");
        model.addAttribute("pageMode",    "add");
        return "employee-form";
    }

    // ── EDIT FORM ─────────────────────────────────────────────────────────────

    @GetMapping("/employees/edit/{id}")
    public String editForm(@PathVariable Long id, Model model,
                           RedirectAttributes ra) {

        return service.getById(id).map(emp -> {
            model.addAttribute("employee",    emp);
            model.addAttribute("departments", service.getAllDepartments());
            model.addAttribute("formTitle",   "Edit Employee");
            model.addAttribute("pageMode",    "edit");
            return "employee-form";
        }).orElseGet(() -> {
            ra.addFlashAttribute("errorMsg", "Employee not found (ID: " + id + ")");
            return "redirect:/employees";
        });
    }

    // ── SAVE (CREATE & UPDATE) ────────────────────────────────────────────────

    @PostMapping("/employees/save")
    public String save(@Valid @ModelAttribute("employee") Employee employee,
                       BindingResult result,
                       Model model,
                       RedirectAttributes ra) {

        if (result.hasErrors()) {
            model.addAttribute("departments", service.getAllDepartments());
            model.addAttribute("formTitle",   employee.getId() == null ? "Add New Employee" : "Edit Employee");
            model.addAttribute("pageMode",    employee.getId() == null ? "add" : "edit");
            return "employee-form";
        }

        boolean isNew = (employee.getId() == null);
        service.save(employee);

        ra.addFlashAttribute("successMsg",
                isNew ? "Employee \"" + employee.getName() + "\" added successfully!"
                      : "Employee \"" + employee.getName() + "\" updated successfully!");
        return "redirect:/employees";
    }

    // ── DETAIL VIEW ───────────────────────────────────────────────────────────

    @GetMapping("/employees/view/{id}")
    public String viewEmployee(@PathVariable Long id, Model model,
                                RedirectAttributes ra) {
        return service.getById(id).map(emp -> {
            model.addAttribute("employee", emp);
            return "employee-detail";
        }).orElseGet(() -> {
            ra.addFlashAttribute("errorMsg", "Employee not found (ID: " + id + ")");
            return "redirect:/employees";
        });
    }

    // ── DELETE ────────────────────────────────────────────────────────────────

    @GetMapping("/employees/delete/{id}")
    public String delete(@PathVariable Long id, RedirectAttributes ra) {
        service.getById(id).ifPresentOrElse(
            emp -> {
                service.delete(id);
                ra.addFlashAttribute("successMsg", "Employee \"" + emp.getName() + "\" deleted successfully!");
            },
            () -> ra.addFlashAttribute("errorMsg", "Employee not found (ID: " + id + ")")
        );
        return "redirect:/employees";
    }

    // ── TOGGLE STATUS ─────────────────────────────────────────────────────────

    @GetMapping("/employees/toggle/{id}")
    public String toggleStatus(@PathVariable Long id, RedirectAttributes ra) {
        service.getById(id).ifPresentOrElse(
            emp -> {
                String newStatus = "Active".equals(emp.getStatus()) ? "Inactive" : "Active";
                emp.setStatus(newStatus);
                service.save(emp);
                ra.addFlashAttribute("successMsg",
                        emp.getName() + " marked as " + newStatus + ".");
            },
            () -> ra.addFlashAttribute("errorMsg", "Employee not found")
        );
        return "redirect:/employees";
    }
}

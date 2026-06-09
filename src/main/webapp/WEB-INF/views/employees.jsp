<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Employees — EMP Track</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="Employees" scope="request"/>
<%@ include file="fragments/header.jsp" %>

    <!-- Page Header -->
    <div class="page-header animate-rise">
        <div>
            <h1 class="font-display">
                <span class="glow-text"><i class="fas fa-users" style="margin-right:10px"></i>Employees</span>
            </h1>
            <p>${empPage.totalElements} employee(s) found</p>
        </div>
        <a href="/employees/add" class="btn btn-primary">
            <i class="fas fa-user-plus"></i> Add Employee
        </a>
    </div>

    <!-- Filter Bar -->
    <form method="get" action="/employees" id="filterForm">
        <div class="filter-bar animate-rise delay-1">
            <div class="filter-group" style="flex:2;min-width:200px">
                <label><i class="fas fa-magnifying-glass"></i> Search</label>
                <input type="text" name="search" value="${search}" class="form-control"
                       placeholder="Name or email…">
            </div>
            <div class="filter-group">
                <label><i class="fas fa-sitemap"></i> Department</label>
                <select name="department" class="form-control" onchange="this.form.submit()">
                    <option value="">All Departments</option>
                    <c:forEach var="dept" items="${departments}">
                        <option value="${dept}" ${department eq dept ? 'selected' : ''}>${dept}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group">
                <label><i class="fas fa-toggle-on"></i> Status</label>
                <select name="status" class="form-control" onchange="this.form.submit()">
                    <option value="">All Status</option>
                    <option value="Active"   ${status eq 'Active'   ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${status eq 'Inactive' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            <div class="filter-group">
                <label><i class="fas fa-arrow-up-wide-short"></i> Sort By</label>
                <select name="sort" class="form-control" onchange="this.form.submit()">
                    <option value="id"           ${sort eq 'id'           ? 'selected' : ''}>Default</option>
                    <option value="name"         ${sort eq 'name'         ? 'selected' : ''}>Name A→Z</option>
                    <option value="-name"        ${sort eq '-name'        ? 'selected' : ''}>Name Z→A</option>
                    <option value="department"   ${sort eq 'department'   ? 'selected' : ''}>Department</option>
                    <option value="salary"       ${sort eq 'salary'       ? 'selected' : ''}>Salary ↑</option>
                    <option value="-salary"      ${sort eq '-salary'      ? 'selected' : ''}>Salary ↓</option>
                    <option value="joiningDate"  ${sort eq 'joiningDate'  ? 'selected' : ''}>Joining ↑</option>
                    <option value="-joiningDate" ${sort eq '-joiningDate' ? 'selected' : ''}>Joining ↓</option>
                </select>
            </div>
            <div class="filter-group" style="min-width:auto;flex:0">
                <label>&nbsp;</label>
                <div style="display:flex;gap:8px">
                    <button type="submit" class="btn btn-primary" style="height:38px;padding:0 16px">
                        <i class="fas fa-magnifying-glass"></i>
                    </button>
                    <a href="/employees" class="btn btn-outline" style="height:38px;padding:0 14px;display:flex;align-items:center">
                        <i class="fas fa-xmark"></i>
                    </a>
                </div>
            </div>
            <input type="hidden" name="page" value="0">
        </div>
    </form>

    <!-- Table -->
    <div class="table-wrapper animate-rise delay-2">
        <div class="table-scroll">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Employee</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Salary (₹)</th>
                        <th>Location</th>
                        <th>Joined</th>
                        <th>Status</th>
                        <th style="text-align:center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty employees}">
                            <tr>
                                <td colspan="9" style="text-align:center;padding:56px;color:var(--text-3)">
                                    <i class="fas fa-users-slash" style="font-size:36px;display:block;margin-bottom:14px;opacity:0.3"></i>
                                    <div style="font-size:15px;font-weight:600;margin-bottom:6px;color:var(--text-2)">No employees found</div>
                                    <a href="/employees" style="color:var(--cyan)">Clear filters</a> or
                                    <a href="/employees/add" style="color:var(--cyan)">add a new employee</a>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="e" items="${employees}">
                                <tr>
                                    <td style="color:var(--text-3);font-size:12px">#${e.id}</td>
                                    <td>
                                        <div style="display:flex;align-items:center;gap:10px">
                                            <div style="
                                                width:32px;height:32px;border-radius:9px;flex-shrink:0;
                                                background:linear-gradient(135deg,var(--cyan2),var(--violet2));
                                                display:flex;align-items:center;justify-content:center;
                                                font-weight:700;font-size:12px;color:#fff;
                                            ">${fn:substring(e.name,0,1)}</div>
                                            <span class="fw-600">${e.name}</span>
                                        </div>
                                    </td>
                                    <td style="color:var(--text-2);font-size:12.5px">${e.email}</td>
                                    <td><span class="badge badge-dept">${e.department}</span></td>
                                    <td class="fw-600" style="color:var(--emerald)">
                                        ₹<fmt:formatNumber value="${e.salary}" type="number" maxFractionDigits="0"/>
                                    </td>
                                    <td style="color:var(--text-2);font-size:12.5px">
                                        <c:choose>
                                            <c:when test="${not empty e.location}">${e.location}</c:when>
                                            <c:otherwise><span style="color:var(--text-3)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size:12.5px;color:var(--text-2)">
                                        <c:choose>
                                            <c:when test="${not empty e.joiningDate}">${e.joiningDate}</c:when>
                                            <c:otherwise><span style="color:var(--text-3)">—</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${e.status eq 'Active' ? 'badge-active' : 'badge-inactive'}">
                                            <span class="dot"></span>${e.status}
                                        </span>
                                    </td>
                                    <td style="text-align:center">
                                        <div style="display:flex;gap:5px;justify-content:center;flex-wrap:wrap">
                                            <a href="/employees/view/${e.id}" class="btn btn-view btn-sm" title="View">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="/employees/edit/${e.id}" class="btn btn-edit btn-sm" title="Edit">
                                                <i class="fas fa-pen"></i>
                                            </a>
                                            <a href="/employees/toggle/${e.id}" class="btn btn-toggle btn-sm" title="Toggle Status">
                                                <i class="fas fa-power-off"></i>
                                            </a>
                                            <button onclick="confirmDelete('${e.name}', '/employees/delete/${e.id}')"
                                                    class="btn btn-delete btn-sm" title="Delete">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <div style="padding:18px 20px;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;border-top:1px solid var(--border)">
                <span style="font-size:12.5px;color:var(--text-3)">
                    Page ${currentPage + 1} of ${totalPages}
                </span>
                <div class="pagination">
                    <c:choose>
                        <c:when test="${currentPage == 0}">
                            <span class="disabled"><i class="fas fa-chevron-left"></i></span>
                        </c:when>
                        <c:otherwise>
                            <a href="/employees?page=${currentPage-1}&search=${search}&department=${department}&status=${status}&sort=${sort}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                    <c:forEach begin="0" end="${totalPages-1}" var="i">
                        <c:if test="${i >= currentPage-2 and i <= currentPage+2}">
                            <c:choose>
                                <c:when test="${i == currentPage}"><span class="active">${i+1}</span></c:when>
                                <c:otherwise>
                                    <a href="/employees?page=${i}&search=${search}&department=${department}&status=${status}&sort=${sort}">${i+1}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                    <c:choose>
                        <c:when test="${currentPage+1 >= totalPages}">
                            <span class="disabled"><i class="fas fa-chevron-right"></i></span>
                        </c:when>
                        <c:otherwise>
                            <a href="/employees?page=${currentPage+1}&search=${search}&department=${department}&status=${status}&sort=${sort}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>

<%@ include file="fragments/footer.jsp" %>
</body>
</html>

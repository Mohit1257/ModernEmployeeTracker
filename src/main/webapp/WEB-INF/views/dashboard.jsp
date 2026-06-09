<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard — EMP Track</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="Dashboard" scope="request"/>
<%@ include file="fragments/header.jsp" %>

    <div class="page-header animate-rise">
        <div>
            <h1 class="font-display">
                <span class="glow-text"><i class="fas fa-chart-pie" style="margin-right:10px"></i>Dashboard</span>
            </h1>
            <p>Welcome back — here's your workforce at a glance.</p>
        </div>
        <a href="/employees/add" class="btn btn-primary">
            <i class="fas fa-user-plus"></i> Add Employee
        </a>
    </div>

    <div class="stats-grid">
        <div class="stat-card" data-color="blue">
            <div class="stat-icon blue"><i class="fas fa-users"></i></div>
            <div>
                <div class="stat-value" data-target="${stats.totalEmployees}">0</div>
                <div class="stat-label">Total Employees</div>
            </div>
        </div>
        <div class="stat-card" data-color="green">
            <div class="stat-icon green"><i class="fas fa-user-check"></i></div>
            <div>
                <div class="stat-value" data-target="${stats.activeEmployees}">0</div>
                <div class="stat-label">Active Employees</div>
            </div>
        </div>
        <div class="stat-card" data-color="red">
            <div class="stat-icon red"><i class="fas fa-user-times"></i></div>
            <div>
                <div class="stat-value" data-target="${stats.inactiveEmployees}">0</div>
                <div class="stat-label">Inactive</div>
            </div>
        </div>
        <div class="stat-card" data-color="purple">
            <div class="stat-icon purple"><i class="fas fa-sitemap"></i></div>
            <div>
                <div class="stat-value" data-target="${stats.totalDepartments}">0</div>
                <div class="stat-label">Departments</div>
            </div>
        </div>
        <div class="stat-card" data-color="orange">
            <div class="stat-icon orange"><i class="fas fa-indian-rupee-sign"></i></div>
            <div>
                <div class="stat-value" data-target="${stats.totalSalaryExpense}" data-prefix="&#8377;" style="-webkit-text-fill-color:unset;color:var(--amber)">&#8377;0</div>
                <div class="stat-label">Monthly Salary</div>
            </div>
        </div>
    </div>

    <div class="charts-row">
        <div class="chart-card animate-rise delay-1">
            <h3><i class="fas fa-chart-bar"></i> Employees by Department</h3>
            <div class="chart-wrapper"><canvas id="deptChart"></canvas></div>
        </div>
        <div class="chart-card animate-rise delay-2">
            <h3><i class="fas fa-circle-half-stroke"></i> Active vs Inactive</h3>
            <div class="chart-wrapper"><canvas id="statusChart"></canvas></div>
        </div>
    </div>

    <div class="card animate-rise delay-3" data-reveal="300">
        <div style="display:flex;align-items:center;gap:10px;margin-bottom:18px">
            <i class="fas fa-clock-rotate-left text-accent" style="font-size:16px"></i>
            <h3 class="font-display" style="font-size:15px;font-weight:600">Recently Added</h3>
            <a href="/employees" class="btn btn-outline btn-sm ms-auto">View All <i class="fas fa-arrow-right" style="font-size:11px"></i></a>
        </div>
        <div class="table-scroll">
            <table class="data-table">
                <thead>
                    <tr><th>Employee</th><th>Department</th><th>Joined</th><th>Status</th><th style="text-align:center">Action</th></tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty stats.recentEmployees}">
                            <tr><td colspan="5" style="text-align:center;padding:40px;color:var(--text-3)">
                                <i class="fas fa-inbox" style="font-size:28px;display:block;margin-bottom:10px;opacity:0.4"></i>
                                No employees yet — <a href="/employees/add" style="color:var(--cyan)">add your first one</a>
                            </td></tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="e" items="${stats.recentEmployees}">
                                <tr>
                                    <td>
                                        <div style="display:flex;align-items:center;gap:10px">
                                            <div style="width:34px;height:34px;border-radius:10px;flex-shrink:0;background:linear-gradient(135deg,var(--cyan2),var(--violet2));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;color:#fff;">${fn:substring(e.name,0,1)}</div>
                                            <span class="fw-600">${e.name}</span>
                                        </div>
                                    </td>
                                    <td><span class="badge badge-dept">${e.department}</span></td>
                                    <td style="color:var(--text-2);font-size:13px">${e.joiningDate}</td>
                                    <td>
                                        <span class="badge ${e.status eq 'Active' ? 'badge-active' : 'badge-inactive'}">
                                            <span class="dot"></span>${e.status}
                                        </span>
                                    </td>
                                    <td style="text-align:center">
                                        <a href="/employees/view/${e.id}" class="btn btn-view btn-sm"><i class="fas fa-eye"></i></a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

<%@ include file="fragments/footer.jsp" %>

<script>
(function() {
    const labels = [], data = [];
    <c:forEach var="entry" items="${stats.deptChartData}">
    labels.push('${entry.key}');
    data.push(${entry.value});
    </c:forEach>
    const deptCtx   = document.getElementById('deptChart').getContext('2d');
    const statusCtx = document.getElementById('statusChart').getContext('2d');
    buildDeptChart(deptCtx, labels, data);
    buildStatusChart(statusCtx, ${stats.activeEmployees}, ${stats.inactiveEmployees});
})();
</script>
</body>
</html>

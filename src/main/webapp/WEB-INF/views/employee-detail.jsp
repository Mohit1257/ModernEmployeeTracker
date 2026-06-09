<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"      prefix="c"   %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"       prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"  %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${employee.name} — EMP Track</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="Employee Detail" scope="request"/>
<%@ include file="fragments/header.jsp" %>

    <div style="margin-bottom:22px;font-size:12.5px;color:var(--text-3);display:flex;align-items:center;gap:6px" class="animate-fade">
        <a href="/"          style="color:var(--text-3);text-decoration:none;transition:color 0.2s" onmouseover="this.style.color='var(--cyan)'" onmouseout="this.style.color='var(--text-3)'">Dashboard</a>
        <i class="fas fa-chevron-right" style="font-size:9px;opacity:0.5"></i>
        <a href="/employees" style="color:var(--text-3);text-decoration:none;transition:color 0.2s" onmouseover="this.style.color='var(--cyan)'" onmouseout="this.style.color='var(--text-3)'">Employees</a>
        <i class="fas fa-chevron-right" style="font-size:9px;opacity:0.5"></i>
        <span style="color:var(--cyan);font-weight:600">${employee.name}</span>
    </div>

    <div style="max-width:780px">
        <div class="card animate-zoom">
            <div class="detail-header">
                <div class="detail-avatar">${fn:substring(employee.name,0,1)}</div>
                <div style="flex:1;min-width:0">
                    <h2 class="font-display" style="font-size:24px;font-weight:700">${employee.name}</h2>
                    <p style="color:var(--text-2);margin-top:5px;display:flex;align-items:center;gap:7px;font-size:13.5px">
                        <i class="fas fa-envelope" style="color:var(--cyan)"></i>${employee.email}
                    </p>
                    <div style="margin-top:12px;display:flex;gap:8px;flex-wrap:wrap">
                        <span class="badge badge-dept">${employee.department}</span>
                        <span class="badge ${employee.status eq 'Active' ? 'badge-active' : 'badge-inactive'}">
                            <span class="dot"></span>${employee.status}
                        </span>
                    </div>
                </div>
                <div style="display:flex;gap:8px;flex-wrap:wrap;align-self:flex-start">
                    <a href="/employees/edit/${employee.id}" class="btn btn-edit btn-sm"><i class="fas fa-pen"></i> Edit</a>
                    <a href="/employees/toggle/${employee.id}" class="btn btn-toggle btn-sm"><i class="fas fa-power-off"></i></a>
                    <button onclick="confirmDelete('${employee.name}', '/employees/delete/${employee.id}')" class="btn btn-delete btn-sm">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>

            <hr class="divider">

            <div class="detail-grid">
                <div class="detail-item">
                    <div class="di-label"><i class="fas fa-id-badge"></i>Employee ID</div>
                    <div class="di-value glow-text">#${employee.id}</div>
                </div>
                <div class="detail-item">
                    <div class="di-label"><i class="fas fa-sitemap"></i>Department</div>
                    <div class="di-value">${employee.department}</div>
                </div>
                <div class="detail-item">
                    <div class="di-label"><i class="fas fa-indian-rupee-sign"></i>Salary</div>
                    <div class="di-value text-success">
                        &#8377;<fmt:formatNumber value="${employee.salary}" type="number" maxFractionDigits="2"/>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="di-label"><i class="fas fa-location-dot"></i>Location</div>
                    <div class="di-value">
                        <c:choose>
                            <c:when test="${not empty employee.location}">${employee.location}</c:when>
                            <c:otherwise><span style="color:var(--text-3)">Not specified</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="di-label"><i class="fas fa-calendar-days"></i>Joining Date</div>
                    <div class="di-value">
                        <c:choose>
                            <c:when test="${not empty employee.joiningDate}">${employee.joiningDate}</c:when>
                            <c:otherwise><span style="color:var(--text-3)">—</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="detail-item">
                    <div class="di-label"><i class="fas fa-circle-dot"></i>Status</div>
                    <div class="di-value">
                        <span class="badge ${employee.status eq 'Active' ? 'badge-active' : 'badge-inactive'}">
                            <span class="dot"></span>${employee.status}
                        </span>
                    </div>
                </div>
            </div>

            <div style="margin-top:26px">
                <a href="/employees" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Back to Employees</a>
            </div>
        </div>
    </div>

<%@ include file="fragments/footer.jsp" %>
</body>
</html>

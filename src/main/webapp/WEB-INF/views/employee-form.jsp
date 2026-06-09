<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"   %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${formTitle} — EMP Track</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<c:set var="pageTitle" value="${formTitle}" scope="request"/>
<%@ include file="fragments/header.jsp" %>

    <div style="margin-bottom:22px;font-size:12.5px;color:var(--text-3);display:flex;align-items:center;gap:6px" class="animate-fade">
        <a href="/"          style="color:var(--text-3);text-decoration:none" onmouseover="this.style.color='var(--cyan)'" onmouseout="this.style.color='var(--text-3)'">Dashboard</a>
        <i class="fas fa-chevron-right" style="font-size:9px;opacity:0.5"></i>
        <a href="/employees" style="color:var(--text-3);text-decoration:none" onmouseover="this.style.color='var(--cyan)'" onmouseout="this.style.color='var(--text-3)'">Employees</a>
        <i class="fas fa-chevron-right" style="font-size:9px;opacity:0.5"></i>
        <span style="color:var(--cyan);font-weight:600">${formTitle}</span>
    </div>

    <div style="max-width:640px">
        <div class="card animate-zoom">
            <div class="form-card-header">
                <div class="icon">
                    <i class="fas ${pageMode eq 'add' ? 'fa-user-plus' : 'fa-user-pen'}"></i>
                </div>
                <div>
                    <h2>${formTitle}</h2>
                    <p>
                        <c:choose>
                            <c:when test="${pageMode eq 'add'}">Fill in the details to add a new employee</c:when>
                            <c:otherwise>Update the information below and save changes</c:otherwise>
                        </c:choose>
                    </p>
                </div>
            </div>

            <hr class="divider">

            <sf:form action="/employees/save" method="post" modelAttribute="employee" id="employeeForm">
                <sf:hidden path="id"/>

                <div class="form-row">
                    <div class="field-group">
                        <label for="name"><i class="fas fa-user"></i>Full Name <span style="color:var(--rose)">*</span></label>
                        <sf:input path="name" id="name" cssClass="field-input" placeholder="e.g. Rohit Sharma" required="true"/>
                        <sf:errors path="name" cssClass="invalid-feedback" element="div"/>
                    </div>
                    <div class="field-group">
                        <label for="email"><i class="fas fa-envelope"></i>Email Address <span style="color:var(--rose)">*</span></label>
                        <sf:input path="email" id="email" type="email" cssClass="field-input" placeholder="rohit@example.com" required="true"/>
                        <sf:errors path="email" cssClass="invalid-feedback" element="div"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="field-group">
                        <label for="department"><i class="fas fa-sitemap"></i>Department <span style="color:var(--rose)">*</span></label>
                        <sf:input path="department" id="department" cssClass="field-input" list="deptList" placeholder="e.g. Engineering" required="true"/>
                        <datalist id="deptList">
                            <c:forEach var="dept" items="${departments}">
                                <option value="${dept}"/>
                            </c:forEach>
                        </datalist>
                        <sf:errors path="department" cssClass="invalid-feedback" element="div"/>
                    </div>
                    <div class="field-group">
                        <label for="location"><i class="fas fa-location-dot"></i>Location</label>
                        <sf:input path="location" id="location" cssClass="field-input" placeholder="e.g. Pune"/>
                        <sf:errors path="location" cssClass="invalid-feedback" element="div"/>
                    </div>
                </div>

                <div class="form-row">
                    <div class="field-group">
                        <label for="salary"><i class="fas fa-indian-rupee-sign"></i>Salary (&#8377;) <span style="color:var(--rose)">*</span></label>
                        <sf:input path="salary" id="salary" type="number" step="0.01" min="1" cssClass="field-input" placeholder="55000" required="true"/>
                        <sf:errors path="salary" cssClass="invalid-feedback" element="div"/>
                    </div>
                    <div class="field-group">
                        <label for="joiningDate"><i class="fas fa-calendar-days"></i>Joining Date <span style="color:var(--rose)">*</span></label>
                        <sf:input path="joiningDate" id="joiningDate" type="date" cssClass="field-input" required="true"/>
                        <sf:errors path="joiningDate" cssClass="invalid-feedback" element="div"/>
                    </div>
                </div>

                <div class="field-group">
                    <label for="status"><i class="fas fa-circle-dot"></i>Status <span style="color:var(--rose)">*</span></label>
                    <sf:select path="status" id="status" cssClass="field-input">
                        <sf:option value="Active">&#9989; Active</sf:option>
                        <sf:option value="Inactive">&#9940; Inactive</sf:option>
                    </sf:select>
                    <sf:errors path="status" cssClass="invalid-feedback" element="div"/>
                </div>

                <div style="display:flex;gap:12px;margin-top:6px">
                    <button type="submit" class="btn btn-primary" style="flex:1;justify-content:center">
                        <i class="fas fa-floppy-disk"></i>
                        ${pageMode eq 'add' ? 'Add Employee' : 'Save Changes'}
                    </button>
                    <a href="/employees" class="btn btn-outline"><i class="fas fa-xmark"></i> Cancel</a>
                </div>
            </sf:form>
        </div>
    </div>

<%@ include file="fragments/footer.jsp" %>
</body>
</html>

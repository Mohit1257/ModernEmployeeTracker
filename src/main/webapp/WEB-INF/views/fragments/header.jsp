<%-- fragments/header.jsp — Enhanced UI v2 --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${not empty pageTitle ? pageTitle : 'Dashboard'} — EMP Track</title>

    <%-- Font Awesome CSS (CDN se CSS load karo, JS nahi — faster hai) --%>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"
          crossorigin="anonymous" referrerpolicy="no-referrer"/>

    <%-- Google Fonts --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <%-- App CSS — src/main/resources/static/css/style.css --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>

    <%-- Chart.js — loaded in head so chart helpers are ready --%>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>

<!-- Page Loader -->
<div class="page-loader" id="pageLoader">
    <div class="loader-ring"></div>
    <p>Loading…</p>
</div>

<!-- Toast Container -->
<div class="toast-container" id="toastContainer">
    <c:if test="${not empty successMsg}">
        <div class="toast toast-success">
            <span class="toast-icon"><i class="fas fa-circle-check"></i></span>
            <span>${successMsg}</span>
            <span class="toast-close"><i class="fas fa-xmark"></i></span>
        </div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="toast toast-error">
            <span class="toast-icon"><i class="fas fa-circle-exclamation"></i></span>
            <span>${errorMsg}</span>
            <span class="toast-close"><i class="fas fa-xmark"></i></span>
        </div>
    </c:if>
</div>

<div class="app-layout">

    <!-- ── Sidebar ────────────────────────────────────────── -->
    <aside class="sidebar" id="sidebar">
        <a href="${pageContext.request.contextPath}/" class="sidebar-brand">
            <div class="brand-icon"><i class="fas fa-bolt"></i></div>
            <div class="brand-text">EMP<span>Track</span></div>
        </a>

        <nav class="sidebar-nav">
            <div class="nav-section-label">Main</div>
            <a href="${pageContext.request.contextPath}/" class="nav-item">
                <i class="fas fa-chart-pie"></i> Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/employees" class="nav-item">
                <i class="fas fa-users"></i> Employees
            </a>
            <a href="${pageContext.request.contextPath}/employees/add" class="nav-item">
                <i class="fas fa-user-plus"></i> Add Employee
            </a>

            <div class="nav-section-label">Manage</div>
            <a href="${pageContext.request.contextPath}/employees?status=Active" class="nav-item">
                <i class="fas fa-user-check"></i> Active Staff
            </a>
            <a href="${pageContext.request.contextPath}/employees?status=Inactive" class="nav-item">
                <i class="fas fa-user-times"></i> Inactive Staff
            </a>
        </nav>

        <div class="sidebar-footer">
            <div style="margin-bottom:4px">EMP<span style="color:var(--cyan)">Track</span> v1.0</div>
            <div>© 2026 Employee Tracker</div>
        </div>
    </aside>

    <!-- ── Main Content ───────────────────────────────────── -->
    <main class="main-content">

        <!-- Topbar -->
        <header class="topbar">
            <button class="sidebar-toggle" id="sidebarToggle" aria-label="Menu">
                <i class="fas fa-bars"></i>
            </button>

            <c:choose>
                <c:when test="${not empty pageTitle}">
                    <div class="topbar-title">${pageTitle}</div>
                </c:when>
                <c:otherwise>
                    <div class="topbar-title">Dashboard</div>
                </c:otherwise>
            </c:choose>

            <div class="topbar-actions">
                <div class="online-dot" title="System Online"></div>
                <button class="theme-toggle" id="themeToggle" title="Toggle theme">
                    <i class="fas fa-sun"></i>
                </button>
                <a href="${pageContext.request.contextPath}/employees/add"
                   class="btn btn-primary btn-sm" style="gap:6px">
                    <i class="fas fa-plus"></i><span class="hide-xs">New</span>
                </a>
                <div class="topbar-avatar" title="Admin">A</div>
            </div>
        </header>

        <!-- Page Content Wrapper -->
        <div class="page-body">

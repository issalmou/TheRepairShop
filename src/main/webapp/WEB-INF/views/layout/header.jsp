<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TheRepairShop - Device & Client Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        :root {
            --sidebar-width: 16.5rem;
            --sidebar-bg: #111827;
            --sidebar-accent: #f97316;
            --sidebar-muted: #9ca3af;
            --primary: #ea580c;
            --primary-hover: #c2410c;
        }
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            background-color: #f9fafb;
        }
        /* Override cyan buttons globally to align with warm orange brand theme */
        .btn-cyan {
            background-color: var(--primary) !important;
            border-color: var(--primary) !important;
            color: #fff !important;
            font-weight: 500;
            transition: all 0.2s ease-in-out;
        }
        .btn-cyan:hover, .btn-cyan:focus {
            background-color: var(--primary-hover) !important;
            border-color: var(--primary-hover) !important;
            color: #fff !important;
            box-shadow: 0 4px 12px rgba(234, 88, 12, 0.2) !important;
        }
        /* Override standard Bootstrap badges with premium soft-tint styling */
        .text-bg-warning, .bg-warning {
            background-color: #fef3c7 !important;
            color: #d97706 !important;
            border: 1px solid rgba(217, 119, 6, 0.15) !important;
        }
        .text-bg-info, .bg-info {
            background-color: #dbeafe !important;
            color: #2563eb !important;
            border: 1px solid rgba(37, 99, 235, 0.15) !important;
        }
        .text-bg-success, .bg-success {
            background-color: #dcfce7 !important;
            color: #16a34a !important;
            border: 1px solid rgba(22, 163, 74, 0.15) !important;
        }
        .text-bg-secondary, .bg-secondary {
            background-color: #f3f4f6 !important;
            color: #4b5563 !important;
            border: 1px solid rgba(75, 85, 99, 0.15) !important;
        }

        .mobile-topbar {
            background: var(--sidebar-bg);
            color: #fff;
            padding: 0.75rem 1rem;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.18);
        }
        .mobile-topbar .brand {
            color: #fff;
            font-weight: 700;
            font-size: 1.1rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        .app-sidebar {
            width: var(--sidebar-width);
            background: var(--sidebar-bg);
            color: #fff;
            border-right: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 2px 0 12px rgba(0, 0, 0, 0.12);
            display: flex;
            flex-direction: column;
            padding: 1.5rem 1rem;
        }
        .app-sidebar .sidebar-brand {
            font-weight: 700;
            font-size: 1.2rem;
            color: #fff;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.65rem;
            margin-bottom: 1.5rem;
        }
        .app-sidebar .brand-icon {
            width: 2.2rem;
            height: 2.2rem;
            border-radius: 0.6rem;
            background: linear-gradient(135deg, #ff9a1f 0%, #ff7e00 100%);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            color: #fff;
        }
        .app-sidebar .nav-link {
            color: rgba(255, 255, 255, 0.75);
            border-radius: 0.55rem;
            padding: 0.5rem 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.65rem;
        }
        .app-sidebar .nav-link i {
            width: 1.25rem;
            text-align: center;
        }
        .app-sidebar .nav-link:hover,
        .app-sidebar .nav-link:focus {
            background: rgba(255, 255, 255, 0.1);
            color: #fff;
        }
        .app-sidebar .nav-section {
            color: var(--sidebar-muted);
            font-size: 0.7rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            margin: 1rem 0 0.35rem 0.5rem;
        }
        .sidebar-form label {
            color: var(--sidebar-muted);
        }
        .sidebar-form .form-select {
            background-color: #2b3038;
            color: #fff;
            border-color: rgba(255, 255, 255, 0.2);
        }
        .sidebar-form .form-select:focus {
            border-color: var(--sidebar-accent);
            box-shadow: 0 0 0 0.2rem rgba(255, 149, 0, 0.2);
        }
        .sidebar-nav {
            flex-grow: 1;
        }
        .sidebar-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-nav li {
            list-style: none;
        }
        .sidebar-footer {
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            margin-top: auto;
        }
        .desktop-sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 1000;
        }
        body {
            padding-left: var(--sidebar-width);
        }
        @media (max-width: 991.98px) {
            .desktop-sidebar {
                display: none;
            }
            body {
                padding-left: 0;
            }
            .mobile-sidebar {
                width: 85vw;
                max-width: 20rem;
            }
        }
        .brand-gradient {
            background: linear-gradient(135deg, #ff9500 0%, #ff7e00 100%);
        }
        .app-panel {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }
        .dashboard-panel {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 0.5rem;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
        }
        .app-panel-title {
            font-size: 1rem;
            font-weight: 600;
            color: #1f2937;
            margin-bottom: 0;
        }
        .btn-cyan {
            background-color: #06b6d4;
            border-color: #06b6d4;
            color: #fff;
        }
        .btn-cyan:hover {
            background-color: #0891b2;
            border-color: #0891b2;
            color: #fff;
        }
        .form-control:focus,
        .form-select:focus {
            border-color: #0ea5e9;
            box-shadow: 0 0 0 0.2rem rgba(14, 165, 233, 0.15);
        }
        .table-app thead th {
            font-size: 0.7rem;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            color: #6b7280;
            font-weight: 600;
            border-bottom: 1px solid #e5e7eb;
            padding-top: 1rem;
            padding-bottom: 1rem;
        }
        .table-app tbody td {
            padding-top: 0.85rem;
            padding-bottom: 0.85rem;
        }
        .section-icon {
            width: 2.25rem;
            height: 2.25rem;
            border-radius: 0.375rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
    </style>
</head>
<body>
    <%-- After an internal forward to a JSP, requestURI is the JSP path; use the original public URL. --%>
    <c:set var="redirectUri" value="${pageContext.request.requestURI}" />
    <c:set var="redirectQs" value="${pageContext.request.queryString}" />
    <c:if test="${not empty requestScope['javax.servlet.forward.request_uri']}">
        <c:set var="redirectUri" value="${requestScope['javax.servlet.forward.request_uri']}" />
        <c:set var="redirectQs" value="${requestScope['javax.servlet.forward.query_string']}" />
    </c:if>

    <!-- Desktop Sidebar (always visible) -->
    <nav class="app-sidebar desktop-sidebar d-none d-lg-flex">
        <a class="sidebar-brand" href="${pageContext.request.contextPath}/">
            <span class="brand-icon"><i class="bi bi-tools"></i></span>
            <span>TheRepairShop</span>
        </a>
        <div class="sidebar-nav">
            <ul class="nav flex-column gap-1">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/tracking">
                        <i class="bi bi-search"></i>
                        <span>Track a Repair</span>
                    </a>
                </li>
                <li class="nav-item">
                <sec:authorize access="hasAnyRole('OWNER','REPARATEUR')">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="bi bi-graph-up"></i>
                            <span>Dashboard</span>
                        </a>
                    </li>
                </sec:authorize>
                <sec:authorize access="hasRole('ADMIN')">
                    <li class="nav-section">Admin</li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/users/owners">
                            <i class="bi bi-person-badge"></i>
                            <span>Owners Management</span>
                        </a>
                    </li>
                </sec:authorize>
                <sec:authorize access="hasRole('OWNER')">
                    <li class="nav-section">Management</li>
                    <c:if test="${ownerShopSwitcher}">
                        <li class="nav-item sidebar-form">
                            <form method="post" action="${pageContext.request.contextPath}/shops/select"
                                  class="d-flex flex-column gap-2">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                <input type="hidden" name="redirect"
                                       value="${redirectUri}${empty redirectQs ? '' : '?'}${redirectQs}">
                                <label class="form-label small mb-0" for="shopScopeSelect">Shop</label>
                                <select name="shopId" id="shopScopeSelect" class="form-select form-select-sm"
                                        onchange="this.form.submit()">
                                    <option value="" ${empty ownerSelectedShopId ? 'selected' : ''}>All shops</option>
                                    <c:forEach var="s" items="${ownerShopsForSwitcher}">
                                        <option value="${s.id}" ${ownerSelectedShopId eq s.id ? 'selected' : ''}>
                                            <c:out value="${s.name}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </form>
                        </li>
                    </c:if>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/shops">
                            <i class="bi bi-shop"></i>
                            <span>Shops</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/users/manage">
                            <i class="bi bi-people"></i>
                            <span>Repairers Management</span>
                        </a>
                    </li>
                    <li class="nav-section">Reports</li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/reports/overdue">
                            <i class="bi bi-calendar-x"></i>
                            <span>Overdue Repairs</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/reports/workload">
                            <i class="bi bi-bar-chart-line"></i>
                            <span>Technician Workload</span>
                        </a>
                    </li>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('OWNER','REPARATEUR')">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/clients">
                            <i class="bi bi-people"></i>
                            <span>Clients</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/repairs">
                            <i class="bi bi-wrench"></i>
                            <span>Repairs</span>
                        </a>
                    </li>
                </sec:authorize>

            </ul>
        </div>
        <sec:authorize access="isAuthenticated()">
            <div class="sidebar-footer mt-auto pt-3">
                <a href="${pageContext.request.contextPath}/profile" class="d-flex align-items-center gap-3 mb-3 p-2 rounded text-decoration-none" style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='rgba(255, 255, 255, 0.1)'" onmouseout="this.style.background='rgba(255, 255, 255, 0.05)'">
                    <div class="rounded-circle d-flex align-items-center justify-content-center text-white" style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #ff9500 0%, #ff7e00 100%); font-weight: bold; font-size: 1.1rem; flex-shrink: 0;">
                        <i class="bi bi-person-fill"></i>
                    </div>
                    <div class="d-flex flex-column min-w-0">
                        <span class="text-white fw-semibold text-truncate" style="font-size: 0.9rem;">
                            <sec:authentication property="principal.username" />
                        </span>
                        <span class="mt-1">
                            <sec:authorize access="hasRole('ADMIN')"><span class="badge bg-danger bg-opacity-25 text-danger border border-danger border-opacity-50" style="font-size: 0.65rem;">Admin</span></sec:authorize>
                            <sec:authorize access="hasRole('OWNER')"><span class="badge bg-warning bg-opacity-25 text-warning border border-warning border-opacity-50" style="font-size: 0.65rem;">Owner</span></sec:authorize>
                            <sec:authorize access="hasRole('REPARATEUR')"><span class="badge bg-info bg-opacity-25 text-info border border-info border-opacity-50" style="font-size: 0.65rem;">Repairer</span></sec:authorize>
                        </span>
                    </div>
                </a>
                <form method="post" action="${pageContext.request.contextPath}/logout">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                    <button type="submit" class="btn btn-outline-light w-100">Logout</button>
                </form>
            </div>
        </sec:authorize>
    </nav>

    <!-- Mobile Top Bar + Offcanvas Sidebar -->
    <div class="mobile-topbar d-lg-none">
        <div class="d-flex align-items-center gap-2">
            <button class="btn btn-outline-light btn-sm" type="button" data-bs-toggle="offcanvas"
                    data-bs-target="#mobileSidebar" aria-controls="mobileSidebar">
                <i class="bi bi-list"></i>
            </button>
            <a class="brand" href="${pageContext.request.contextPath}/">
                <i class="bi bi-tools"></i> TheRepairShop
            </a>
        </div>
    </div>

    <nav class="app-sidebar mobile-sidebar offcanvas offcanvas-start" tabindex="-1" id="mobileSidebar"
         aria-labelledby="mobileSidebarLabel">
        <div class="offcanvas-header">
            <h5 class="offcanvas-title" id="mobileSidebarLabel">TheRepairShop</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"
                    aria-label="Close"></button>
        </div>
        <div class="offcanvas-body d-flex flex-column p-0 pt-3">
            <div class="sidebar-nav px-3">
                <ul class="nav flex-column gap-1">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/tracking">
                            <i class="bi bi-search"></i>
                            <span>Track a Repair</span>
                        </a>
                    </li>
                    <sec:authorize access="hasRole('ADMIN')">
                        <li class="nav-section">Admin</li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/users/owners">
                                <i class="bi bi-person-badge"></i>
                                <span>Owners Management</span>
                            </a>
                        </li>
                    </sec:authorize>
                    <sec:authorize access="hasRole('OWNER')">
                        <li class="nav-section">Management</li>
                        <c:if test="${ownerShopSwitcher}">
                            <li class="nav-item sidebar-form px-0">
                                <form method="post" action="${pageContext.request.contextPath}/shops/select"
                                      class="d-flex flex-column gap-2">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                                    <input type="hidden" name="redirect"
                                           value="${redirectUri}${empty redirectQs ? '' : '?'}${redirectQs}">
                                    <label class="form-label small mb-0" for="shopScopeSelectMobile">Shop</label>
                                    <select name="shopId" id="shopScopeSelectMobile" class="form-select form-select-sm"
                                            onchange="this.form.submit()">
                                        <option value="" ${empty ownerSelectedShopId ? 'selected' : ''}>All shops</option>
                                        <c:forEach var="s" items="${ownerShopsForSwitcher}">
                                            <option value="${s.id}" ${ownerSelectedShopId eq s.id ? 'selected' : ''}>
                                                <c:out value="${s.name}"/>
                                            </option>
                                        </c:forEach>
                                    </select>
                                </form>
                            </li>
                        </c:if>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/shops">
                                <i class="bi bi-shop"></i>
                                <span>Shops</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/users/manage">
                                <i class="bi bi-people"></i>
                                <span>Repairers Management</span>
                            </a>
                        </li>
                        <li class="nav-section">Reports</li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/reports/overdue">
                                <i class="bi bi-calendar-x"></i>
                                <span>Overdue Repairs</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/reports/workload">
                                <i class="bi bi-bar-chart-line"></i>
                                <span>Technician Workload</span>
                            </a>
                        </li>
                    </sec:authorize>
                    <sec:authorize access="hasAnyRole('OWNER','REPARATEUR')">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/clients">
                                <i class="bi bi-people"></i>
                                <span>Clients</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/repairs">
                                <i class="bi bi-wrench"></i>
                                <span>Repairs</span>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                                <i class="bi bi-graph-up"></i>
                                <span>Dashboard</span>
                            </a>
                        </li>
                    </sec:authorize>

                </ul>
            </div>
            <sec:authorize access="isAuthenticated()">
                <div class="sidebar-footer mx-3 mt-auto mb-3 pt-3">
                    <a href="${pageContext.request.contextPath}/profile" class="d-flex align-items-center gap-3 mb-3 p-2 rounded text-decoration-none" style="background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); cursor: pointer; transition: background 0.2s;" onmouseover="this.style.background='rgba(255, 255, 255, 0.1)'" onmouseout="this.style.background='rgba(255, 255, 255, 0.05)'">
                        <div class="rounded-circle d-flex align-items-center justify-content-center text-white" style="width: 2.5rem; height: 2.5rem; background: linear-gradient(135deg, #ff9500 0%, #ff7e00 100%); font-weight: bold; font-size: 1.1rem; flex-shrink: 0;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div class="d-flex flex-column min-w-0">
                            <span class="text-white fw-semibold text-truncate" style="font-size: 0.9rem;">
                                <sec:authentication property="principal.username" />
                            </span>
                            <span class="mt-1">
                                <sec:authorize access="hasRole('ADMIN')"><span class="badge bg-danger bg-opacity-25 text-danger border border-danger border-opacity-50" style="font-size: 0.65rem;">Admin</span></sec:authorize>
                                <sec:authorize access="hasRole('OWNER')"><span class="badge bg-warning bg-opacity-25 text-warning border border-warning border-opacity-50" style="font-size: 0.65rem;">Owner</span></sec:authorize>
                                <sec:authorize access="hasRole('REPARATEUR')"><span class="badge bg-info bg-opacity-25 text-info border border-info border-opacity-50" style="font-size: 0.65rem;">Repairer</span></sec:authorize>
                            </span>
                        </div>
                    </a>
                    <form method="post" action="${pageContext.request.contextPath}/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
                        <button type="submit" class="btn btn-outline-light w-100">Logout</button>
                    </form>
                </div>
            </sec:authorize>
        </div>
    </nav>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

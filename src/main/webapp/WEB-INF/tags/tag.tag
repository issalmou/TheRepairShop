<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<%@ attribute name="title" required="true" type="java.lang.String" %>
<%@ attribute name="activePage" required="false" type="java.lang.String" %>
<%@ variable name-given="content" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title} - Repair Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .sidebar-link {
            transition: all 0.3s ease;
            color: #6B7280;
        }
        .sidebar-link:hover {
            background-color: #F3F4F6;
            color: #111827;
        }
        .sidebar-link.active {
            background-color: #ff9500;
            color: white;
        }
        .sidebar-item-label {
            font-size: 0.875rem;
            font-weight: 500;
        }
        .help-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>
<body class="bg-gray-100">
<div class="flex h-screen">
    <!-- Sidebar -->
    <div class="w-64 bg-white border-r border-gray-200 flex flex-col">
        <!-- Logo Section -->
        <div class="p-6 border-b border-gray-200">
            <div class="flex items-center gap-2 mb-2">
                <div class="w-8 h-8 bg-orange-500 rounded flex items-center justify-center text-white font-bold text-sm">S</div>
                <h2 class="text-sm font-bold text-gray-900">The Repair Shop</h2>
            </div>
        </div>

        <!-- Navigation -->
        <nav class="flex-1 overflow-y-auto p-4">
            <!-- Dashboard -->
            <div class="mb-8">
                <a href="${pageContext.request.contextPath}/dashboard"
                   class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''} flex items-center gap-3 py-3 px-4 rounded-lg sidebar-item-label">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"></path>
                    </svg>
                    Dashboard
                </a>
            </div>

            <!-- Main Menu - Role Based -->
            <ul class="space-y-2 mb-8">
                <sec:authorize access="hasAnyRole('ADMIN', 'OWNER')">
                    <li>
                        <a href="#" class="sidebar-link flex items-center gap-3 py-2 px-4 rounded-lg sidebar-item-label">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path>
                            </svg>
                            Réparateurs
                        </a>
                    </li>
                    <li>
                        <a href="#" class="sidebar-link flex items-center gap-3 py-2 px-4 rounded-lg sidebar-item-label">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
                            </svg>
                            Magasins
                        </a>
                    </li>
                </sec:authorize>
                <sec:authorize access="hasAnyRole('ADMIN', 'OWNER', 'REPARATOR')">
                    <li>
                        <a href="#" class="sidebar-link flex items-center gap-3 py-2 px-4 rounded-lg sidebar-item-label">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                            </svg>
                            Opérations
                        </a>
                    </li>
                </sec:authorize>
            </ul>

            <!-- Profile Section -->
            <div class="mb-4">
                <ul class="space-y-2">
                    <li>
                        <a href="${pageContext.request.contextPath}/profile"
                           class="sidebar-link ${activePage == 'profile' ? 'active' : ''} flex items-center gap-3 py-2 px-4 rounded-lg sidebar-item-label">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                            </svg>
                            Profile
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- User Section & Logout -->
        <div class="p-4 border-t border-gray-200">
            <!-- User Info -->
            <div class="flex items-center gap-3 mb-4 pb-4 border-b border-gray-200">
                <div class="w-10 h-10 bg-blue-500 rounded-full flex items-center justify-center text-white font-bold">
                    <sec:authentication property="name" var="username"/>
                    ${username.substring(0,1).toUpperCase()}
                </div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-semibold text-gray-900 truncate"><sec:authentication property="name" /></p>
                    <p class="text-xs text-gray-500 truncate">
                        <c:forEach var="authority" items="${pageContext.request.userPrincipal.authorities}">
                            <c:if test="${authority.authority.startsWith('ROLE_')}">
                                ${authority.authority.replace('ROLE_', '')}
                            </c:if>
                        </c:forEach>
                    </p>
                </div>
            </div>

            <!-- Logout Button -->
            <a href="${pageContext.request.contextPath}/signout"
               class="w-full block text-center bg-red-500 hover:bg-red-600 text-white font-bold py-3 rounded-lg transition duration-200">
                Déconnexion
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="flex-1 overflow-auto">
        <!-- Header -->
        <div class="bg-white shadow-sm border-b">
            <div class="px-6 py-4">
                <h1 class="text-2xl font-semibold text-gray-800">${title}</h1>
            </div>
        </div>

        <!-- Content -->
        <div class="p-6">
            <jsp:doBody />
        </div>
    </div>
</div>
</body>
</html>
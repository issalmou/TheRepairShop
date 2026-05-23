<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - TheRepairShop</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        input:focus {
            outline: none;
            border-color: #0EA5E9;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }
        .brand-gradient {
            background: linear-gradient(135deg, #ff9500 0%, #ff7e00 100%);
        }
    </style>
</head>
<body class="bg-white">
<div class="min-h-screen flex">
    <!-- Brand panel (hidden on small screens) -->
    <div class="hidden lg:flex lg:w-1/2 brand-gradient flex-col justify-center items-center text-white px-16">
        <div class="text-center max-w-md">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-white/20 mb-6">
                <i class="bi bi-tools text-3xl"></i>
            </div>
            <h2 class="text-3xl font-bold mb-3">TheRepairShop</h2>
            <p class="text-white/90 text-sm leading-relaxed">
                Manage repairs, clients, and technicians from one place. Track progress and keep your shop running smoothly.
            </p>
        </div>
    </div>

    <!-- Form section -->
    <div class="w-full lg:w-1/2 flex items-center justify-center px-8 py-12">
        <div class="w-full max-w-md">
            <div class="lg:hidden flex items-center gap-2 mb-8">
                <span class="inline-flex items-center justify-center w-10 h-10 rounded-lg brand-gradient text-white">
                    <i class="bi bi-tools text-lg"></i>
                </span>
                <span class="text-xl font-bold text-gray-900">TheRepairShop</span>
            </div>

            <h1 class="text-4xl font-bold text-orange-600 mb-2">Welcome back</h1>
            <p class="text-gray-500 text-sm mb-8">Enter your username and password to sign in</p>

            <c:if test="${not empty param.error}">
                <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg mb-6 text-sm flex items-start gap-2.5 shadow-sm">
                    <span class="mt-0.5 text-red-500"><i class="bi bi-exclamation-circle-fill"></i></span>
                    <div>
                        <span class="font-semibold block mb-0.5">Authentication failed</span>
                        <c:choose>
                            <c:when test="${param.error eq 'disabled'}">
                                This account has been deactivated. Please contact your administrator.
                            </c:when>
                            <c:when test="${param.error eq 'locked'}">
                                This account has been locked.
                            </c:when>
                            <c:otherwise>
                                Invalid username or password. Please try again.
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty param.logout}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg mb-6 text-sm">
                    You have been logged out successfully.
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post" class="space-y-6">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div>
                    <label for="username" class="block text-sm font-semibold text-gray-800 mb-2">Username</label>
                    <input type="text" id="username" name="username" placeholder="Username" required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm placeholder-gray-400 transition focus:border-orange-500 focus:ring-2 focus:ring-orange-100"/>
                </div>

                <div>
                    <label for="password" class="block text-sm font-semibold text-gray-800 mb-2">Password</label>
                    <input type="password" id="password" name="password" placeholder="Password" required
                           class="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm placeholder-gray-400 transition focus:border-orange-500 focus:ring-2 focus:ring-orange-100"/>
                </div>

                <button type="submit"
                        class="w-full bg-orange-600 hover:bg-orange-700 text-white font-bold py-3 rounded-lg transition duration-200 shadow-sm hover:shadow-md">
                    Sign in
                </button>

                <div class="text-center pt-2">
                    <p class="text-gray-600 text-sm">
                        Need to check a repair?
                        <a href="${pageContext.request.contextPath}/tracking"
                           class="text-orange-600 hover:text-orange-700 font-semibold">Track a repair</a>
                    </p>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>

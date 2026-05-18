<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Repair Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .toggle-checkbox:checked {
            background-color: #111827;
            border-color: #111827;
        }
        input:focus {
            outline: none;
            border-color: #0EA5E9;
            box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.1);
        }
    </style>
</head>
<body class="bg-white">
<div class="min-h-screen flex items-center justify-center">
    <!-- Form Section -->
    <div class="flex flex-col justify-center px-12 py-12">
        <div class="max-w-md">
            <h1 class="text-4xl font-bold text-blue-600 mb-2">Welcome back</h1>
            <p class="text-gray-500 text-sm mb-8">Enter your email and password to sign in</p>

            <c:if test="${not empty error}">
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                    ${success}
                </div>
            </c:if>

            <%--@elvariable id="loginRequest" type="ma.aabs.repair_management_system.dto.LoginRequest"--%>
            <form:form action="${pageContext.request.contextPath}/login" method="post" modelAttribute="loginRequest" class="space-y-6">
                <!-- Email Field -->
                <div>
                    <label class="block text-sm font-semibold text-gray-800 mb-2">Email</label>
                    <form:input path="usernameOrEmail" id="usernameOrEmail"
                                placeholder="Email"
                                class="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm placeholder-gray-400 transition"
                                required="required"/>
                    <form:errors path="usernameOrEmail" cssClass="text-red-500 text-xs mt-1 block"/>
                </div>

                <!-- Password Field -->
                <div>
                    <label class="block text-sm font-semibold text-gray-800 mb-2">Password</label>
                    <form:password path="password" id="password"
                                   placeholder="Password"
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg text-sm placeholder-gray-400 transition"
                                   required="required"/>
                    <form:errors path="password" cssClass="text-red-500 text-xs mt-1 block"/>
                </div>

                <!-- Remember Me Checkbox -->
                <div class="flex items-center">
                    <input type="checkbox" id="remember" name="remember" class="toggle-checkbox w-5 h-5 rounded cursor-pointer">
                    <label for="remember" class="ml-2 text-sm text-gray-700 cursor-pointer">Remember me</label>
                </div>

                <!-- Sign In Button -->
                <button type="submit"
                        class="w-full bg-cyan-500 hover:bg-cyan-600 text-white font-bold py-3 rounded-lg transition duration-200">
                    Sign in
                </button>

                <!-- Sign Up Link -->
                <div class="text-center pt-2">
                    <p class="text-gray-600 text-sm">
                        Don't have an account?
                        <a href="${pageContext.request.contextPath}/register" class="text-cyan-500 hover:text-cyan-600 font-semibold">Sign up</a>
                    </p>
                </div>

                <!-- Forgot Password Link -->
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/forgot-password" class="text-gray-500 hover:text-gray-700 text-sm">
                        Forgot password?
                    </a>
                </div>
            </form:form>
        </div>
    </div>
</div>
</body>
</html>
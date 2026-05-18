<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mot de passe oublié - Repair Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">
            Mot de passe oublié
        </h2>

        <p class="text-gray-600 text-sm mb-4 text-center">
            Entrez votre email et nous vous enverrons un lien pour réinitialiser votre mot de passe.
        </p>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${error}
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
                ${success}
            </div>
        </c:if>

        <form:form action="${pageContext.request.contextPath}/forgot-password" method="post" modelAttribute="forgotPasswordRequest">
            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
                    Adresse email
                </label>
                <form:input path="email" id="email" type="email"
                            class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                            required="required"
                            placeholder="votre@email.com"/>
                <form:errors path="email" cssClass="text-red-500 text-xs mt-1"/>
            </div>

            <div class="flex items-center justify-between mb-4">
                <button type="submit"
                        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline w-full">
                    Envoyer le lien de réinitialisation
                </button>
            </div>
        </form:form>

        <div class="text-center">
            <a href="${pageContext.request.contextPath}/auth/login" class="text-blue-500 hover:text-blue-700 text-sm">
                Retour à la connexion
            </a>
        </div>
    </div>
</div>
</body>
</html>
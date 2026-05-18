<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réinitialiser mon mot de passe - Repair Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex items-center justify-center">
    <div class="bg-white p-8 rounded-lg shadow-md w-96">
        <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">
            Nouveau mot de passe
        </h2>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                ${error}
            </div>
        </c:if>

        <form:form action="${pageContext.request.contextPath}/reset-password" method="post" modelAttribute="resetPasswordRequest">
            <form:hidden path="token"/>
            <form:errors path="*" cssClass="text-red-500 text-xs mt-1 mb-4 block"/>

            <div class="mb-4">
                <label class="block text-gray-700 text-sm font-bold mb-2" for="newPassword">
                    Nouveau mot de passe
                </label>
                <form:password path="newPassword" id="newPassword"
                               class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                               required="required"
                               minlength="6"
                               placeholder="Au moins 6 caractères"/>
                <p class="text-xs text-gray-500 mt-1">Minimum 6 caractères</p>
                <form:errors path="newPassword" cssClass="text-red-500 text-xs mt-1"/>
            </div>

            <div class="mb-6">
                <label class="block text-gray-700 text-sm font-bold mb-2" for="confirmPassword">
                    Confirmer le nouveau mot de passe
                </label>
                <form:password path="confirmPassword" id="confirmPassword"
                               class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                               required="required"
                               minlength="6"
                               placeholder="Répétez le mot de passe"/>
                <form:errors path="confirmPassword" cssClass="text-red-500 text-xs mt-1"/>
            </div>

            <div class="flex items-center justify-between mb-4">
                <button type="submit"
                        class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline w-full">
                    Réinitialiser mon mot de passe
                </button>
            </div>
        </form:form>

        <div class="text-center">
            <a href="${pageContext.request.contextPath}/login" class="text-blue-500 hover:text-blue-700 text-sm">
                Retour à la connexion
            </a>
        </div>
    </div>
</div>
</body>
</html>
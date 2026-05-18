<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Propriétaire - Repair Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="min-h-screen flex items-center justify-center py-12">
    <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-2xl">
        <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">
            Inscription Propriétaire
        </h2>

        <p class="text-center text-gray-600 mb-4">
            Créez votre compte propriétaire pour gérer votre entreprise de réparation
        </p>

        <c:if test="${not empty error}">
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                    ${error}
            </div>
        </c:if>

        <form:form action="${pageContext.request.contextPath}/register" method="post" modelAttribute="registerRequest">
            <!-- Informations personnelles -->
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-3 pb-2 border-b">
                    Informations personnelles
                </h3>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="firstName">
                            Prénom *
                        </label>
                        <form:input path="firstName" id="firstName"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                    required="required"/>
                        <form:errors path="firstName" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="lastName">
                            Nom *
                        </label>
                        <form:input path="lastName" id="lastName"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                    required="required"/>
                        <form:errors path="lastName" cssClass="text-red-500 text-xs mt-1"/>
                    </div>
                </div>
            </div>

            <!-- Informations de compte -->
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-3 pb-2 border-b">
                    Informations de compte
                </h3>
                <div class="space-y-4">
                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="username">
                            Nom d'utilisateur *
                        </label>
                        <form:input path="username" id="username"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                    required="required"/>
                        <form:errors path="username" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="email">
                            Email *
                        </label>
                        <form:input path="email" id="email" type="email"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                    required="required"/>
                        <form:errors path="email" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="password">
                            Mot de passe *
                        </label>
                        <form:password path="password" id="password"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                       required="required"/>
                        <p class="text-xs text-gray-500 mt-1">Minimum 6 caractères</p>
                        <form:errors path="password" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="confirmPassword">
                            Confirmer le mot de passe *
                        </label>
                        <form:password path="confirmPassword" id="confirmPassword"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                       required="required"/>
                        <form:errors path="confirmPassword" cssClass="text-red-500 text-xs mt-1"/>
                    </div>
                </div>
            </div>

            <!-- Informations professionnelles -->
            <div class="mb-6">
                <h3 class="text-lg font-semibold text-gray-800 mb-3 pb-2 border-b">
                    Informations professionnelles
                </h3>
                <div class="space-y-4">
                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="companyName">
                            Nom de l'entreprise *
                        </label>
                        <form:input path="companyName" id="companyName"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                    required="required"/>
                        <form:errors path="companyName" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="taxNumber">
                            Numéro de taxe (TVA)
                        </label>
                        <form:input path="taxNumber" id="taxNumber"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        <form:errors path="taxNumber" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="businessLicense">
                            Licence commerciale
                        </label>
                        <form:input path="businessLicense" id="businessLicense"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        <form:errors path="businessLicense" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="website">
                            Site web
                        </label>
                        <form:input path="website" id="website" type="url"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                    placeholder="https://"/>
                        <form:errors path="website" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="phoneNumber">
                            Téléphone
                        </label>
                        <form:input path="phoneNumber" id="phoneNumber"
                                    class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        <form:errors path="phoneNumber" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="address">
                            Adresse
                        </label>
                        <form:textarea path="address" id="address" rows="2"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"/>
                        <form:errors path="address" cssClass="text-red-500 text-xs mt-1"/>
                    </div>

                    <div>
                        <label class="block text-gray-700 text-sm font-bold mb-2" for="companyDescription">
                            Description de l'entreprise
                        </label>
                        <form:textarea path="companyDescription" id="companyDescription" rows="3"
                                       class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                                       placeholder="Décrivez votre entreprise..."/>
                        <form:errors path="companyDescription" cssClass="text-red-500 text-xs mt-1"/>
                    </div>
                </div>
            </div>

            <div class="mb-6">
                <button type="submit"
                        class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline w-full transition">
                    S'inscrire comme Propriétaire
                </button>
            </div>
        </form:form>

        <div class="text-center">
            <p class="text-gray-600">
                Déjà un compte ?
                <a href="${pageContext.request.contextPath}/login" class="text-blue-500 hover:text-blue-700">
                    Se connecter
                </a>
            </p>
        </div>
    </div>
</div>
</body>
</html>